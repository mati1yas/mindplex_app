import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/authentication/controllers/auth_controller.dart';
import 'package:mindplex/features/comment/controllers/comment_controller.dart';

import '../../../../utils/colors.dart';
import '../../models/comment_model.dart';

class CommentReplyDialog extends StatelessWidget {
  const CommentReplyDialog({
    super.key,
    required this.commentController,
    required this.authController,
    required this.comment,
    required this.index,
  });

  final CommentController commentController;
  final int index;
  final AuthController authController;
  final Comment comment;

  @override
  Widget build(BuildContext context) {
    TextEditingController replyTextEditingController = TextEditingController();
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Replying to ${commentController.comments[index].commentAuthor}'s comment",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: replyTextEditingController,
              minLines: 1,
              maxLines: 5,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
              textAlignVertical: TextAlignVertical.center,
              cursorColor: commentSectionColor,
              decoration: const InputDecoration(
                fillColor: Color.fromARGB(255, 3, 46, 90),
                filled: true,
                hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                hintText: 'Leave a reply',
                contentPadding: EdgeInsets.all(14),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
              onTap: () {
                if (authController.isGuestUser.value) {
                  authController.guestReminder(context);
                }
              },
              onChanged: (val) {
                // TODO: handle this callback using the textFieldController in the controller
              },
            ),
            OutlinedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(commentSectionColor)),
              onPressed: () {
                if (authController.isGuestUser.value) {
                  authController.guestReminder(context);
                } else {
                  replyTextEditingController.text == ''
                      ? null
                      : commentController.onClickReply(
                          comment, replyTextEditingController.text);
                }
              },
              child: Text(
                'Reply',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
