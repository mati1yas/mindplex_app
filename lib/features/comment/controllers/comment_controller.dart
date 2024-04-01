import 'package:delta_to_html/delta_to_html.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/comment/api_service/comment_api_service.dart';
import 'package:mindplex/features/user_profile_displays/controllers/DraftedPostsController.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';
import 'package:mindplex/features/user_profile_displays/services/profileServices.dart';
import 'package:flutter_quill/flutter_quill.dart' as ql;
import 'package:mindplex/utils/Toster.dart';

import '../models/comment_model.dart';

class CommentController extends GetxController {
  CommentController({required this.post_slug}); // the constructor

  final commentApiService = CommentApiService();
  final profileService = ProfileServices();

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
  RxBool loadingcommentorMpxr = false.obs;

  final TextEditingController commentTextEditingController =
      TextEditingController(); // we'll use this controller for writing new comments and replies
  final TextEditingController updateTextEditingController =
      TextEditingController(); // we'll use this controller for updating comments and replies
  ql.QuillController quillController = ql.QuillController.basic();
  final _focusNode = Rx<FocusNode?>(FocusNode());
  FocusNode? get focusNode => _focusNode.value;

  @override
  void onInit() {
    prepareComments();
    _focusNode.value?.unfocus();

    super.onInit();
  }

  void prepareComments() async {
    try {
      loadingComments.value = true;
      comments.value =
          await commentApiService.fetchComments(post_slug: post_slug);

      loadCommentorMpxr(comments);

      loadCommentReplies(comments);

      loadingComments.value = false;
    } catch (e) {
      throw e.toString();
    }
  }

  void fetchMoreComments() async {
    loadingMoreComments.value = true;

    var fetchedComments = await commentApiService.fetchComments(
        post_slug: post_slug, page: currentPage + 1);
    if (fetchedComments.isNotEmpty) {
      currentPage += 1;
      startPosition.value = comments.length;
      comments.addAll(fetchedComments);
      loadCommentorMpxr(fetchedComments);
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

  void loadCommentorMpxr(List<Comment> fetchedComments) async {
    loadingcommentorMpxr.value = true;

    try {
      for (var i = 0; i < fetchedComments.length; i++) {
        final userMpxr = await profileService.getUserReputation(
            userId: int.parse(fetchedComments[i].userId ?? "0"));

        comments[startPosition.value + i].commentorMpxr = userMpxr.mpxr;
      }
    } catch (e) {
      throw e;
    }

    loadingcommentorMpxr.value = false;
  }

  onClickPost() async {
    // create a comment object on the server and get the newly created comment back

    try {
      String extractedComment = extractCommentContentFromTextEditor();
      var newComment = await commentApiService.createComment(
          post_slug: post_slug, content: extractedComment);

      comments.value!.insert(0, newComment);
      comments.refresh();
      resetComment();
      commentTextEditingController.clear();
      update();
    } catch (e) {
      Toster(
          message: 'Failed To Post comment , Please Try again Latter ',
          duration: 1);
    }
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

// we have helper functions below s
  String extractCommentContentFromTextEditor() {
    final lines =
        DeltaToHTML.encodeJson(quillController.document.toDelta().toJson())
            .split('<br>');
    final postContent = lines.map((line) => '<p>$line</p>').join('');
    return postContent;
  }

  Future<void> resetComment() async {
    quillController.replaceText(
      0,
      quillController.document.length,
      '',
      TextSelection(baseOffset: 0, extentOffset: 0),
    );
  }

  @override
  void onClose() {
    _focusNode.value?.unfocus();
    resetComment();

    super.onClose();
  }

  @override
  void dispose() {
    resetComment();
    commentTextEditingController.dispose();
    updateTextEditingController.dispose();
    super.dispose();
  }
}
