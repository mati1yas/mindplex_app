import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/comment.dart';

class CommentController extends GetxController {
  late String lessonId;
  int currentPage = 1; // the page number we're at (related to *pagination*)

  String? profileName = '';
  String? userName = '';
  String? profileImage = '';

  final TextEditingController commentTextEditingController =
      TextEditingController(); // we'll use this controller for writing new comments and replies
  final TextEditingController updateTextEditingController =
      TextEditingController(); // we'll use this controller for updating comments and replies

  //test field focus
  final _focusNode = Rx<FocusNode?>(FocusNode());
  FocusNode? get focusNode => _focusNode.value;

  //bulk data for comment section
  var comments = Rx<List<Comment>?>(null);

  // we use this boolean to know when we're loading and show a progress bar.
  var loadingMoreComments = false.obs;

  // we use this boolean to decide if we show the 'more comments' button or not.
  var moreCommentsAvailable = true.obs;

  CommentController({required this.lessonId}); // the constructor

  @override
  void onInit() {
    getProfileDetails();
    prepareComments();
    _focusNode.value?.unfocus();

    super.onInit();
  }

  void prepareComments() async {
    comments.value = await ApiProvider().fetchComments(lessonId: lessonId);
  }

  void fetchMoreComments() async {
    loadingMoreComments = RxBool(true);
    comments.refresh();
    var moreComments = await ApiProvider()
        .fetchComments(lessonId: lessonId, page: currentPage + 1);
    if (moreComments.isNotEmpty) {
      currentPage += 1;
      comments.value!.addAll(moreComments);
    } else {
      moreCommentsAvailable = RxBool(false);
    }
    loadingMoreComments = RxBool(false);
    comments.refresh();
  }

  onClickPost() async {
    // create a comment object on the server and get the newly created comment back
    var newComment = await ApiProvider().createComment(
        lessonId: lessonId, content: commentTextEditingController.text);
    // add the comment object to the comments list
    comments.value!.insert(0, newComment);
    comments.refresh();
    commentTextEditingController.clear();
    update();
  }

  onClickReply(Comment comment, String replyText) async {
    // create a comment object on the server
    var newComment = await ApiProvider().createComment(
        lessonId: lessonId, content: replyText, parent: comment.id.toString());
    // add the comment object to the replies list of the parent comment # make sure get updates the view
    comment.replies ??= [];
    comment.replies!.insert(0, newComment);
    comments.refresh();
    commentTextEditingController.clear();
    Get.back();
  }

  onUpdateComment(Comment comment, String newContent) async {
    // update the comment object on the server
    var updateSuccessful = await ApiProvider().updateComment(
        commentId: comment.id.toString(), newContent: newContent);
    // update the comment object in the comments list and refresh
    if (updateSuccessful == true) {
      comment.content = newContent;
      comments.refresh();
    }
    updateTextEditingController.clear();
    Get.back();
  }

  onDeleteComment(Comment comment) async {
    // create a comment object on the server
    var deleteSuccessful =
        await ApiProvider().deleteComment(commentId: comment.id);
    // remove the comment from the comments list if it's deleted successfully from the server
    if (deleteSuccessful == true) {
      comments.value!.remove(comment);
    }
    comments.refresh();
  }

  onDeleteReply(Comment reply, Comment parent) async {
    // delete the reply from the server
    var deleteSuccessful =
        await ApiProvider().deleteComment(commentId: reply.id);
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
    success = await ApiProvider()
        .commentLikeDislike(comment.id.toString(), like: !comment.isUserLiked);
    if (success == true) {
      comment.isUserLiked = !comment.isUserLiked;
      comments.refresh();
    }
  }

  Future getProfileDetails() async {
    final result = await SharedPreferences.getInstance();
    profileName = result.getString('name');
    userName = result.getString('username');
    profileImage = result.getString('image');
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
