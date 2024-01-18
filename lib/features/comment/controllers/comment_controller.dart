import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/comment/api_service/comment_api_service.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';

import '../models/comment_model.dart';

class CommentController extends GetxController {
  CommentController({required this.post_slug}); // the constructor

  final commentApiService = CommentApiService();

  final String post_slug;
  int currentPage = 1; // the page number we're at (related to *pagination*)

  String? profileName = '';
  String? userName = '';
  String? profileImage = '';

  RxInt startPosition = 0.obs;

  RxList<Comment> comments = <Comment>[].obs;

  RxBool loadingComments = false.obs;
  RxBool loadingMoreComments = false.obs;
  RxBool moreCommentsAvailable = true.obs;
  RxBool loadingCommentReply = false.obs;

  final TextEditingController commentTextEditingController =
      TextEditingController(); // we'll use this controller for writing new comments and replies
  final TextEditingController updateTextEditingController =
      TextEditingController(); // we'll use this controller for updating comments and replies

  final _focusNode = Rx<FocusNode?>(FocusNode());
  FocusNode? get focusNode => _focusNode.value;

  @override
  void onInit() {
    prepareComments();
    _focusNode.value?.unfocus();

    super.onInit();
  }

  void prepareComments() async {
    loadingComments.value = true;
    comments.value =
        await commentApiService.fetchComments(post_slug: post_slug);

    loadCommentReplies(comments);

    loadingComments.value = false;
  }

  void fetchMoreComments() async {
    loadingMoreComments.value = true;

    var fetchedComments = await commentApiService.fetchComments(
        post_slug: post_slug, page: currentPage + 1);
    if (fetchedComments.isNotEmpty) {
      currentPage += 1;
      startPosition.value = comments.length;
      comments.addAll(fetchedComments);

      loadCommentReplies(fetchedComments);
    } else {
      moreCommentsAvailable.value = false;
    }
    loadingMoreComments.value = false;
  }

  void loadCommentReplies(List<Comment> fetchedComments) async {
    loadingCommentReply.value = true;

    try {
      for (var i = 0; i < fetchedComments.length; i++) {
        var comment = fetchedComments[i];
        if (comment.replyCount != 0) {
          var replies = await commentApiService.fetchComments(
              post_slug: post_slug, parent: comment.commentID.toString());
          comment.replies!.value = replies;
          comments[startPosition.value + i].replies!.value = replies;
        }
      }
    } catch (e) {}

    loadingCommentReply.value = false;
  }

  onClickPost() async {
    // create a comment object on the server and get the newly created comment back
    var newComment = await commentApiService.createComment(
        post_slug: post_slug, content: commentTextEditingController.text);
    // add the comment object to the comments list
    comments.value!.insert(0, newComment);
    comments.refresh();
    commentTextEditingController.clear();
    update();
  }

  onClickReply(Comment comment, String replyText) async {
    // create a comment object on the server
    try {
      var newComment = await commentApiService.createComment(
          post_slug: post_slug,
          content: replyText,
          parent: comment.commentID.toString());
      // add the comment object to the replies list of the parent comment # make sure get updates the view
      comment.replies ??= <Comment>[].obs;
      comment.replies!.insert(0, newComment);
      comments.refresh();
      commentTextEditingController.clear();
    } catch (e) {}
    Get.back();
  }

  onUpdateComment(Comment comment, String newContent) async {
    // update the comment object on the server
    var updateSuccessful = await commentApiService.updateComment(
        commentId: comment.commentID.toString(), newContent: newContent);
    // update the comment object in the comments list and refresh
    if (updateSuccessful == true) {
      comment.commentContent = newContent;
      comments.refresh();
    }
    updateTextEditingController.clear();
    Get.back();
  }

  onDeleteComment(Comment comment) async {
    // create a comment object on the server
    var deleteSuccessful = await commentApiService.deleteComment(
        commentId: comment.commentID ?? "");
    // remove the comment from the comments list if it's deleted successfully from the server
    if (deleteSuccessful == true) {
      comments.remove(comment);
    }
    comments.refresh();
  }

  onDeleteReply(Comment reply, Comment parent) async {
    // delete the reply from the server
    var deleteSuccessful =
        await commentApiService.deleteComment(commentId: reply.commentID ?? "");
    // remove the reply from the replies list of the parent comment if it's deleted successfully from the server
    if (deleteSuccessful == true) {
      parent.replies?.remove(reply);
    }
    comments.refresh();
  }

  onToggleLike(comment) async {
    // this method toggles a comment between like and default states.
    // the underlying implementation has a like-dislike but the interface provided to the user
    // only has like and default states (there's no 'unlike' button users will see)
    bool? success;
    success = await commentApiService.commentLikeDislike(comment.id.toString(),
        like: !comment.isUserLiked);
    if (success == true) {
      comment.isUserLiked = !comment.isUserLiked;
      comments.refresh();
    }
  }

  Future getProfileDetails() async {
    ProfileController profileController = Get.find();
    profileController.getAuthenticatedUser();

    profileName = profileController.authenticatedUser.value.userDisplayName;
    userName = profileController.authenticatedUser.value.username;

    profileImage = profileController.authenticatedUser.value.image;
  }

  @override
  void onClose() {
    _focusNode.value?.unfocus();
    super.onClose();
  }

  @override
  void dispose() {
    commentTextEditingController.dispose();
    updateTextEditingController.dispose();
    super.dispose();
  }
}
