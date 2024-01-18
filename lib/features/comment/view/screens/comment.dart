import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mindplex/features/authentication/controllers/auth_controller.dart';
import 'package:mindplex/features/comment/controllers/comment_controller.dart';
import 'package:mindplex/features/comment/view/widgets/comment_tile.dart';

import '../../../../utils/colors.dart';

class MyWidgetComment extends StatelessWidget {
  MyWidgetComment(
      {super.key, required this.post_slug, required this.comment_number});

  final String post_slug;
  final String comment_number;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommentController(post_slug: post_slug));
    final theme = Theme.of(context);
    AuthController authController = Get.find();
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
                          'Comments (${comment_number})',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.displayLarge?.copyWith(
                            fontSize: 16,
                            color: commentSectionColor,
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
                            backgroundColor: Colors.white,
                            /*

                          foregroundImage: CachedNetworkImageProvider(
                              controller.profileImage!),
                              */
                            backgroundImage:
                                NetworkImage(controller.profileImage ?? "")),
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
                              cursorColor: commentSectionColor,
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(90, 56, 56, 56),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                                hintText: 'Leave a Comment',
                                contentPadding: EdgeInsets.all(14),
                                border: InputBorder.none,
                              ),
                              onTap: () {
                                if (authController.isGuestUser.value) {
                                  authController.guestReminder(context);
                                  controller.focusNode!.unfocus();
                                }
                              },
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
                        child: OutlinedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  commentSectionColor)),
                          onPressed: () {
                            if (authController.isGuestUser.value) {
                              authController.guestReminder(context);
                            } else {
                              controller.commentTextEditingController.text == ''
                                  ? null
                                  : controller.onClickPost();
                            }
                          },
                          child: Text(
                            'Post',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => controller.loadingComments.value
                          ? Center(
                              child: CircularProgressIndicator(
                                color: commentSectionColor,
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: controller.comments.length,
                                itemBuilder: ((context, index) {
                                  var commentOwned = controller
                                          .comments[index].commentAuthor ==
                                      controller.userName;

                                  return Column(
                                    children: [
                                      CommentTile(
                                        index: index,
                                        isOwned: commentOwned,
                                        commentController: controller,
                                        comment: controller.comments[index],
                                        isSubComment: false,
                                      ),
                                      Obx(
                                        () => Container(
                                          margin: EdgeInsets.only(left: 12),
                                          padding: EdgeInsets.only(left: 10),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  left: BorderSide(
                                                      width: 2,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              103,
                                                              232,
                                                              107)))),
                                          child: controller.loadingCommentReply
                                                      .value &&
                                                  index >=
                                                      controller
                                                          .startPosition.value
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : controller.comments[index]
                                                          .replies ==
                                                      null
                                                  ? SizedBox.shrink()
                                                  : ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount: controller
                                                          .comments[index]
                                                          .replies!
                                                          .length,
                                                      itemBuilder:
                                                          (context, index2) {
                                                        var replyOwned = controller
                                                                .comments[index]
                                                                .replies![
                                                                    index2]
                                                                .commentAuthor ==
                                                            controller.userName;
                                                        return CommentTile(
                                                          index: index,
                                                          isOwned: replyOwned,
                                                          commentController:
                                                              controller,
                                                          isSubComment: true,
                                                          comment: controller
                                                              .comments[index]
                                                              .replies![index2],
                                                          parent: controller
                                                              .comments[index],
                                                        );
                                                      }),
                                        ),
                                      ),
                                      const Divider(),
                                    ],
                                  );
                                }),
                              ),
                            ),
                    ),
                    if (controller.moreCommentsAvailable.value)
                      SizedBox(
                        child: TextButton(
                          onPressed: () {
                            controller.fetchMoreComments();
                          },
                          child: controller.loadingMoreComments.value
                              ? SizedBox(
                                  width: 80,
                                  child: LinearProgressIndicator(
                                    color: commentSectionColor,
                                  ),
                                )
                              : Text("More comments",
                                  style: TextStyle(
                                    color: commentSectionColor,
                                  )),
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
