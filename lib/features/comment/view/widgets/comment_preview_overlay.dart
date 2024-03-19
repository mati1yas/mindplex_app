import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/authentication/controllers/auth_controller.dart';
import 'package:mindplex/features/comment/controllers/comment_controller.dart';
import 'package:mindplex/features/drawer/view/widgets/top_user_profile_icon.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class CommentPreviewOverlay extends StatelessWidget {
  CommentPreviewOverlay(
      {super.key,
      required this.currentComment,
      required this.authController,
      required this.profileController,
      required this.commentController});

  final String currentComment;
  final AuthController authController;
  final ProfileController profileController;
  final CommentController commentController;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    profileController.getAuthenticatedUser();

    return FractionallySizedBox(
      widthFactor: 0.8,
      heightFactor: 0.6,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Material(
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xFF0c2b46),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.green)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TopUserProfileIcon(
                          radius: 23,
                          profileController: profileController,
                          authController: authController),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              profileController.authenticatedUser.value
                                      .userDisplayName ??
                                  "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            // Text(
                            //   profileController.userProfile.value.mpxr!
                            //       .toStringAsFixed(5),
                            //   style: TextStyle(
                            //       color: Colors.white,
                            //       fontWeight: FontWeight.w300),
                            // ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Text("0 Minute Ago",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300)),
                      SizedBox(
                        width: 8,
                      )
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    height: height * 0.4,
                    child: Html(
                        onLinkTap: (url, attributes, element) {
                          launchUrl(Uri.parse(url ?? ""));
                        },
                        style: {"*": Style(color: Colors.white)},
                        data: commentController
                            .extractCommentContentFromTextEditor())),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.pink)),
                        onPressed: () {
                          commentController.onClickPost();
                          Get.back();
                        },
                        child: Text("Confirm")),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.purple)),
                        onPressed: () {
                          Get.back();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            Text("Edit"),
                          ],
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
