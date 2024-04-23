import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:html/parser.dart';
import 'package:mindplex/features/authentication/controllers/auth_controller.dart';
import 'package:mindplex/features/blogs/controllers/blog_time_spent_controller.dart';
import 'package:mindplex/features/blogs/controllers/blogs_controller.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';
import 'package:mindplex/features/interaction/controllers/like_dislike_controller.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';
import 'package:mindplex/routes/app_routes.dart';
import 'package:mindplex/utils/colors.dart';
import 'package:mindplex/utils/double_to_string_convertor.dart';
import 'package:readmore/readmore.dart';

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
    required this.blogTimeSpentController,
  });

  final Blog details;
  final ProfileController profileController;
  final BlogTimeSpentController blogTimeSpentController;
  final BlogsController blogsController;
  final int authorIndex;
  final int blogIndex;
  final AuthController authController;
  final LikeDislikeConroller likeDislikeConroller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            openAuthorProfile(details.authors![authorIndex].username ?? "",
                context, authController);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(20),
                child: CircleAvatar(
                  radius: 21,
                  backgroundImage:
                      NetworkImage(details.authors![authorIndex].avatar ?? ""),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * .40,
                margin: EdgeInsets.only(right: 3, top: 20),
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
                    Obx(
                      () => blogTimeSpentController
                              .isLoadinAuthorsReputation.value
                          ? Container(
                              width: 10,
                              height: 10,
                              child: CircularProgressIndicator(
                                color: Colors.green,
                              ),
                            )
                          : Text(
                              details.authors![authorIndex].mpxr != null &&
                                      details.authors![authorIndex].mpxr!
                                              .value !=
                                          null
                                  ? numberToString(
                                          numberValue: details
                                              .authors![authorIndex]
                                              .mpxr!
                                              .value,
                                          decimalPlace: 5) +
                                      " MPXR "
                                  : " - MPXR",
                              // authorIndex == 0
                              //     ? details.reputation.value != null
                              //         ? details.reputation.value!.author!.mpxr!
                              //             .toStringAsFixed(5)
                              //         : " - " + " MPXR"
                              //     : " - ",
                              style: TextStyle(
                                  color: bodyTextColor,
                                  fontWeight: FontWeight.w500),
                            ),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
              Spacer(),
              Obx(() => profileController.authenticatedUser.value.username ==
                      details.authorUsername
                  ? SizedBox()
                  : GestureDetector(
                      onTap: () {
                        if (authController.isGuestUser.value) {
                          authController.guestReminder(context);
                        } else if (!likeDislikeConroller
                            .isSendingFollowRequest.value) {
                          likeDislikeConroller.followUnfollowBlogAuthor(
                              blog: details,
                              blogIndex: blogIndex,
                              authorIndex: authorIndex,
                              userName: details.authors![authorIndex].username!,
                              isFollowing: details
                                  .authors![authorIndex].isFollowing!.value);
                        }
                      },
                      child: Obx(
                        () => Container(
                            padding: const EdgeInsets.only(
                                top: 6, left: 20, right: 20, bottom: 6),
                            margin: EdgeInsets.only(top: 20),
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(235, 41, 92, 120),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: likeDislikeConroller
                                        .isSendingFollowRequest.value &&
                                    likeDislikeConroller.clickedAuthorIndex ==
                                        authorIndex
                                ? Container(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.green,
                                    ))
                                : Obx(
                                    () => Text(
                                      details.authors![authorIndex].isFollowing!
                                              .value
                                          ? 'Unfollow'
                                          : 'Follow',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w200,
                                          color: Colors.white),
                                    ),
                                  )),
                      ),
                    )),
              SizedBox(
                width: 16,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ReadMoreText(
            parse(details.authors![authorIndex].bio).documentElement!.text,
            trimMode: TrimMode.Line,
            trimLines: 2,
            style: TextStyle(color: bodyTextColor, fontWeight: FontWeight.w300),
            colorClickableText: Color.fromARGB(255, 4, 187, 153),
          ),
        ),
      ],
    );
  }

  void openAuthorProfile(String authorUsername, BuildContext context,
      AuthController authController) {
    if (authController.isGuestUser.value) {
      authController.guestReminder(context);
    } else {
      Get.offAndToNamed(AppRoutes.profilePage,
          parameters: {"me": "notme", "username": authorUsername});
    }
  }
}
