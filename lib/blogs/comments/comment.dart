import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mindplex_app/blogs/comments/controller.dart';

import '../../models/comment.dart';

class MyWidgetComment extends GetView<CommentController> {
  MyWidgetComment({super.key, required this.post_slug});

  final String post_slug;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommentController(post_slug: post_slug));
    final theme = Theme.of(context);
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: Color(0xFF0c2b46),
        ),
        child: SingleChildScrollView(
          child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Obx(
                () => Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Comments',
                          style: theme.textTheme.displayLarge?.copyWith(
                            fontSize: 16,
                            color: Color(0xff6eded0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          maxRadius: 24,
                          /*
                          foregroundImage: CachedNetworkImageProvider(
                              controller.profileImage!),
                              */
                          foregroundImage: AssetImage('assets/images/logo.png'),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: TextField(
                              style: TextStyle(
                                color: const Color.fromARGB(255, 46, 46, 46),
                                fontWeight: FontWeight.w400,
                              ),
                              focusNode: controller.focusNode,
                              controller:
                                  controller.commentTextEditingController,
                              textAlignVertical: TextAlignVertical.center,
                              cursorColor: Colors.blue,
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(90, 175, 175, 175),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                                hintText: 'Share something user',
                                contentPadding: EdgeInsets.all(14),
                                border: InputBorder.none,
                              ),
                              onChanged: (val) {
                                // TODO: handle this callback using the textFieldController in the controller
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        /*
                        child: GradientBtn(
                          onPressed: controller
                                      .commentTextEditingController.value
                                      .toString() ==
                                  ''
                              ? null
                              : controller.onClickPost,
                          btnName: 'Post',
                          defaultBtn: true,
                          isPcked: false,
                          width: 65,
                        ),
                        */
                        child: OutlinedButton(
                          onPressed: () {
                            controller.onClickPost();
                          },
                          child: Text(
                            'Post',
                            style: TextStyle(
                              color: Color(0xff6eded0),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (controller.comments.value == null)
                      const Center(
                        child: CircularProgressIndicator(
                          color: Colors.cyan,
                        ),
                      ),
                    if (controller.comments.value != null)
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          // itemCount: controller.comments.value!.length,
                          children: [
                            for (int index = 0;
                                index < controller.comments.value!.length;
                                index++)
                              Builder(
                                builder: (context) {
                                  // make sure we're comparing the right things here. userName, authorName, firstName, etc ... can be misleading.
                                  var commentOwned = controller
                                          .comments.value![index].authorName ==
                                      controller.userName;
                                  return Column(
                                    children: [
                                      _CommentSectionView(
                                        isOwned: commentOwned,
                                        controller: controller,
                                        comment:
                                            controller.comments.value![index],
                                        isSubComment: false,
                                      ),
                                      if (controller
                                              .comments.value![index].replies !=
                                          null)
                                        ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: controller.comments
                                                .value![index].replies!.length,
                                            itemBuilder: (context, index2) {
                                              var replyOwned = controller
                                                      .comments
                                                      .value![index]
                                                      .replies![index2]
                                                      .authorName ==
                                                  controller.userName;
                                              return _CommentSectionView(
                                                isOwned: replyOwned,
                                                controller: controller,
                                                isSubComment: true,
                                                comment: controller
                                                    .comments
                                                    .value![index]
                                                    .replies![index2],
                                                parent: controller
                                                    .comments.value![index],
                                              );
                                            }),
                                      const Divider(),
                                    ],
                                  );
                                },
                              ),
                            if (controller.moreCommentsAvailable.value)
                              SizedBox(
                                child: TextButton(
                                  onPressed: () {
                                    controller.fetchMoreComments();
                                  },
                                  child: controller.loadingMoreComments.value
                                      ? const SizedBox(
                                          width: 80,
                                          child: LinearProgressIndicator(
                                              color: Colors.blue),
                                        )
                                      : const Text("More comments",
                                          style: TextStyle(
                                            color: Color(0xff6eded0),
                                          )),
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

class _CommentSectionView extends StatelessWidget {
  final bool isOwned;
  final bool isSubComment;
  final Comment comment;
  final Comment?
      parent; // the parent is only used when the isSubComment argument is true. otherwise, it's irrelevant; and should not be passed as argument.
  final CommentController controller;
  _CommentSectionView(
      {required this.isOwned,
      required this.isSubComment,
      required this.comment,
      required this.controller,
      this.parent}) {
    if (isSubComment && parent == null) {
      throw Exception(
          "'isSubComment' is true but 'parentCommentId' is not passed. This is not allowed; and it creates problems down the road.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: isSubComment
                ? const EdgeInsets.only(left: 24)
                : const EdgeInsets.all(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isSubComment) const SizedBox(height: 4),
                Row(
                  children: [
                    CircleAvatar(
                      maxRadius: 24,
                      foregroundImage: NetworkImage(
                        comment.imageUrl,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      comment.authorName,
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      formatCommentDate(comment.date),
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  comment.content,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.justify,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => controller.onToggleLike(comment),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                      ),
                      child: Icon(
                        Icons.thumb_up_alt_outlined,
                        color: comment.isUserLiked ? Colors.blue : Colors.grey,
                      ),
                    ),
                    if (!isSubComment)
                      TextButton(
                          onPressed: () {
                            String replyText = '';
                            Get.dialog(Dialog(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                    onChanged: (value) => replyText = value,
                                  ),
                                  TextButton(
                                    onPressed: () => controller.onClickReply(
                                        comment, replyText),
                                    child: const Text('Reply'),
                                  )
                                ],
                              ),
                            ));
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            foregroundColor: Color(0xff6eded0),
                          ),
                          child: const Text(
                            'Reply',
                          )),
                    TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          foregroundColor: Color(0xff6eded0),
                        ),
                        child: const Text(
                          'Report',
                        )),
                    const Spacer(),
                    if (isOwned)
                      TextButton(
                        onPressed: () {
                          if (!isSubComment) {
                            controller.onDeleteComment(comment);
                          } else {
                            controller.onDeleteReply(comment, parent!);
                          }
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                        ),
                        child: const Icon(
                          Boxicons.bx_trash,
                          color: Colors.red,
                        ),
                      ),
                    if (isOwned)
                      TextButton(
                        onPressed: () {
                          controller.updateTextEditingController.value =
                              controller.updateTextEditingController.value
                                  .copyWith(text: comment.content);
                          Get.dialog(Dialog(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                  controller:
                                      controller.updateTextEditingController,
                                  onChanged: (value) {
                                    controller
                                            .updateTextEditingController.value =
                                        controller
                                            .updateTextEditingController.value
                                            .copyWith(text: value);
                                  },
                                ),
                                TextButton(
                                  onPressed: () {
                                    controller.onUpdateComment(
                                        comment,
                                        controller
                                            .updateTextEditingController.text);
                                  },
                                  child: const Text('Update'),
                                )
                              ],
                            ),
                          ));
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          foregroundColor: Color(0xff6eded0),
                        ),
                        child: const Icon(Icons.edit),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String formatCommentDate(String dateString) {
    var commentDate = DateTime.parse("${dateString}Z").toLocal();
    var now = DateTime.now();
    final duration = now.difference(commentDate);
    if (duration.inHours < 1) {
      return "${duration.inMinutes} minutes ago";
    } else if (duration.inDays < 1) {
      return "${duration.inHours} hr${duration.inHours == 1 ? '' : 's'} ago";
    } else if (duration.inDays < 9) {
      return '${duration.inDays} day${duration.inDays == 1 ? '' : 's'} ago';
    } else if (duration.inDays < 365) {
      return DateFormat.MMMd().format(commentDate);
    } else {
      return DateFormat.yMMMd().format(commentDate);
    }
  }
}
