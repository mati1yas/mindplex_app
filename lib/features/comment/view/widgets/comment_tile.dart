import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:mindplex/features/authentication/controllers/auth_controller.dart';
import 'package:mindplex/features/comment/controllers/comment_controller.dart';
import 'package:mindplex/features/comment/models/comment_model.dart';
import 'package:mindplex/features/comment/view/screens/comment.dart';
import 'package:mindplex/features/comment/view/widgets/comment_reply.dart';
import 'package:mindplex/routes/app_routes.dart';
import 'package:mindplex/utils/ago_date_formater.dart';
import 'package:mindplex/utils/colors.dart';
import 'package:mindplex/utils/constatns.dart';
import 'package:share/share.dart';

class CommentTile extends StatelessWidget {
  final int index;
  final bool isOwned;
  final bool isSubComment;

  final Comment comment;
  final Comment?
      parent; // the parent is only used when the isSubComment argument is true. otherwise, it's irrelevant; and should not be passed as argument.
  final CommentController commentController;

  CommentTile({
    required this.isOwned,
    required this.isSubComment,
    required this.comment,
    required this.commentController,
    this.parent,
    required this.index,
  }) {
    if (isSubComment && parent == null) {
      throw Exception(
          "'isSubComment' is true but 'parentCommentId' is not passed. This is not allowed; and it creates problems down the road.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final decodedHtml = parse(comment.commentContent).documentElement!.text;
    AuthController authController = Get.find();
    TextEditingController replyTextEditingController = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isSubComment) const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      print("clicking");
                      if (authController.isGuestUser.value) {
                        authController.guestReminder(context);
                      } else {
                        Get.toNamed(AppRoutes.profilePage, parameters: {
                          "me": "notme",
                          "username": comment.commenterUsername ?? ""
                        });
                      }
                    },
                    child: CircleAvatar(
                      maxRadius: 24,
                      foregroundImage: NetworkImage(
                        comment.authorAvatarUrls ?? "",
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment.commentAuthor ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Obx(
                          () => commentController.loadingcommentorMpxr.value &&
                                  index >= commentController.startPosition.value
                              ? Container(
                                  height: 10,
                                  width: 10,
                                  child: CircularProgressIndicator(
                                    color: Colors.green,
                                  ),
                                )
                              : Text(
                                  comment.commentorMpxr != null
                                      ? comment.commentorMpxr!
                                              .toStringAsFixed(3) +
                                          " MPXR"
                                      : "- MPXR",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    formatCommentDate(comment.commentDate ?? ""),
                    style: theme.textTheme.titleLarge!.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 6),
              Html(style: {
                '*': Style(color: Colors.white),
                'p': Style(
                  color: Colors.white,
                ),
                'b': Style(color: Colors.white, fontWeight: FontWeight.bold),
                'i': Style(color: Colors.white, fontStyle: FontStyle.italic),
                'strong':
                    Style(color: Colors.white, fontWeight: FontWeight.w400),
                'blockquote': Style(
                    color: const Color.fromARGB(255, 211, 211, 211),
                    fontWeight: FontWeight.w400),
              }, data: decodedHtml),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // if (authController.isGuestUser.value) {
                      //   authController.guestReminder(context);
                      // } else {
                      //   if (comment == true) {
                      // likeDislikeConroller.removePreviousInteraction(
                      //     blog: details,
                      //     index: index,
                      //     articleSlug: details.slug ?? "",
                      //     interction: "L");
                      // } else if (comment.isUserLiked == false) {
                      // likeDislikeConroller.likeDislikeArticle(
                      //     blog: details,
                      //     index: index,
                      //     articleSlug: details.slug ?? "",
                      //     interction: "L");
                      //   }
                      // }
                    },
                    icon: true == true
                        ? Icon(
                            Icons.thumb_up_off_alt_rounded,
                            color: Color.fromARGB(255, 73, 255, 179),
                          )
                        : Icon(
                            Icons.thumb_up_off_alt_outlined,
                            color: Colors.white,
                          ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  IconButton(
                    onPressed: () {
                      // if (authController.isGuestUser.value) {
                      //   authController.guestReminder(context);
                      // } else {
                      //   if (details.isUserDisliked.value == true) {
                      //     likeDislikeConroller.removePreviousInteraction(
                      //         blog: details,
                      //         index: index,
                      //         articleSlug: details.slug ?? "",
                      //         interction: "L");
                      //   } else if (details.isUserDisliked.value == false) {
                      //     likeDislikeConroller.likeDislikeArticle(
                      //         blog: details,
                      //         index: index,
                      //         articleSlug: details.slug ?? "",
                      //         interction: "D");
                      //   }

                      //   ;
                      // }
                    },
                    icon: true == true
                        ? Icon(
                            Icons.thumb_down,
                            color: const Color.fromARGB(255, 230, 96, 86),
                          )
                        : Icon(
                            Icons.thumb_down_off_alt_outlined,
                            color: Colors.white,
                          ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      Share.share(comment.commentContent ?? "",
                          subject: 'Sharing Comment');
                    },
                    child: Icon(
                      Icons.share_outlined,
                      color: Colors.white,
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () => commentController.onToggleLike(comment),
                  //   style: TextButton.styleFrom(
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(100.0),
                  //     ),
                  //   ),
                  //   icon: Icon(
                  //     Icons.thumb_up_alt_outlined,
                  //     color: comment.isUserLiked ? Colors.blue : Colors.grey,
                  //   ),
                  // ),
                  // IconButton(
                  //   onPressed: () => commentController.onToggleLike(comment),
                  //   style: TextButton.styleFrom(
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(100.0),
                  //     ),
                  //   ),
                  //   icon: Icon(
                  //     Icons.thumb_up_alt_outlined,
                  //     color: comment.isUserLiked ? Colors.blue : Colors.grey,
                  //   ),
                  // ),
                  const Spacer(),
                  if (!isSubComment)
                    TextButton(
                        onPressed: () {
                          Get.dialog(CommentReplyDialog(
                            commentController: commentController,
                            index: index,
                            authController: authController,
                            comment: comment,
                          ));
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          foregroundColor: pink,
                        ),
                        child: const Text(
                          'Reply',
                        )),
                  // TextButton(
                  //     onPressed: () {},
                  //     style: TextButton.styleFrom(
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(100.0),
                  //       ),
                  //       foregroundColor: commentSectionColor,
                  //     ),
                  //     child: const Text(
                  //       'Report',
                  //     )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
