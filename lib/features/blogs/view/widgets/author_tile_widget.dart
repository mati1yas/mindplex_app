import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:mindplex/features/authentication/controllers/auth_controller.dart';
import 'package:mindplex/features/blogs/controllers/blogs_controller.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';
import 'package:mindplex/features/interaction/controllers/like_dislike_controller.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';
import 'package:mindplex/routes/app_routes.dart';
import 'package:mindplex/utils/colors.dart';

class AuthorsTileWidget extends StatelessWidget {
  const AuthorsTileWidget({
    super.key,
    required this.details,
    required this.profileController,
    required this.blogsController,
    required this.authorIndex,
    required this.blogIndex,
    required this.authController,
    required this.likeDislikeConroller,
  });

  final Blog details;
  final ProfileController profileController;
  final BlogsController blogsController;
  final int authorIndex;
  final int blogIndex;
  final AuthController authController;
  final LikeDislikeConroller likeDislikeConroller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            openAuthorProfile(details.authors![authorIndex].username ?? "",
                context, authController);
          },
          child: Container(
            margin: EdgeInsets.all(20),
            child: CircleAvatar(
              radius: 21,
              backgroundImage: NetworkImage(
                  details.authors![authorIndex].avatar ?? "" ?? ""),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            openAuthorProfile(details.authors![authorIndex].username ?? "",
                context, authController);
          },
          child: Container(
            width: MediaQuery.of(context).size.width * .40,
            margin: EdgeInsets.only(right: 3, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  details.authors![authorIndex].displayName ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      color: titleTextColor),
                ),
                SizedBox(height: 5),
                Text(
                  authorIndex == 0
                      ? details.reputation.value != null
                          ? details.reputation.value!.author!.mpxr!
                              .toStringAsFixed(5)
                          : " - " + " MPXR"
                      : " - ",
                  style: TextStyle(
                      color: bodyTextColor, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 5),
                Text(
                  parse(details.authors![authorIndex].bio)
                      .documentElement!
                      .text,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      color: bodyTextColor, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ),
        Spacer(),
        Obx(() => profileController.authenticatedUser.value.username ==
                blogsController.filteredBlogs[blogIndex].authorUsername
            ? SizedBox()
            : GestureDetector(
                onTap: () {
                  if (authController.isGuestUser.value) {
                    authController.guestReminder(context);
                  } else if (!likeDislikeConroller
                      .isSendingFollowRequest.value) {
                    // likeDislikeConroller.followUnfollowBlogAuthor(blogIndex,
                    //     details.authors![authorIndex].username!, true);
                  }
                },
                child: Container(
                    padding: const EdgeInsets.only(
                        top: 8, left: 25, right: 25, bottom: 8),
                    margin: EdgeInsets.only(top: 15),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(235, 41, 92, 120),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: likeDislikeConroller.isSendingFollowRequest.value
                        ? Container(
                            height: 24,
                            width: 30,
                            child: CircularProgressIndicator())
                        : Text(
                            details.isFollowing!.value ? 'Unfollow' : 'Follow',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w200,
                                color: Colors.white),
                          )),
              )),
        SizedBox(
          width: 16,
        )
      ],
    );
  }

  void openAuthorProfile(String authorUsername, BuildContext context,
      AuthController authController) {
    if (authController.isGuestUser.value) {
      authController.guestReminder(context);
    } else {
      Get.toNamed(AppRoutes.profilePage,
          parameters: {"me": "notme", "username": authorUsername});
    }
  }
}
