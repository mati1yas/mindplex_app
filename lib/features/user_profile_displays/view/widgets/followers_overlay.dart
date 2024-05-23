import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';
import 'package:mindplex/features/user_profile_displays/view/widgets/follower_or_following_user_tile.dart';
import 'package:mindplex/utils/colors.dart';

import '../../../../routes/app_routes.dart';

class FollowersOverlay extends StatefulWidget {
  final ProfileController profileController;
  final bool fetchUserFollowers;

  FollowersOverlay(
      {Key? key,
      required this.profileController,
      required this.fetchUserFollowers});

  @override
  State<FollowersOverlay> createState() => _FollowersOverlayState();
}

class _FollowersOverlayState extends State<FollowersOverlay> {
  @override
  void initState() {
    super.initState();
    widget.profileController.fetchUserFollowers.value =
        widget.fetchUserFollowers;

    widget.profileController.followersPage.value = 0;
    widget.profileController.followingsPage.value = 0;
    widget.profileController.fetchFollowersOrFollowings();
  }

  // Fetch followers method

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.9,
        heightFactor: 0.8,
        child: Material(
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: blogContainerColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 15,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                Text(
                  widget.fetchUserFollowers ? 'Followers' : "Followings",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.0),
                // List of followers
                Obx(
                  () => !widget
                          .profileController.isLoadingFollowerFollowings.value
                      ? Expanded(
                          child: ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                              height: 5,
                            ),
                            controller:
                                widget.profileController.scrollController,
                            itemCount: widget.profileController
                                    .followers_followings.length +
                                (widget.profileController
                                        .reachedEndofFollowersOrFollowings.value
                                    ? 0
                                    : 1), // +1 for the loading spinner if not reached end
                            itemBuilder: (context, index) {
                              if (widget.profileController.followers_followings
                                      .length ==
                                  0) {
                                return Center(
                                  child: Text(
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                      "No ${widget.fetchUserFollowers ? "Followers !" : "Followings !"} "),
                                );
                              }
                              if (index <
                                  widget.profileController.followers_followings
                                      .length) {
                                final follower = widget.profileController
                                    .followers_followings[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.toNamed(AppRoutes.profilePage,
                                          parameters: {
                                            "me": "notme",
                                            "username": follower.username ?? ""
                                          });
                                    },
                                    child: FollowerOrFollowingUserTile(
                                      follower: follower,
                                      profileController:
                                          widget.profileController,
                                    ),
                                  ),
                                );
                              } else if (!widget.profileController
                                  .reachedEndofFollowersOrFollowings.value) {
                                // Loading spinner at the bottom
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              } else {
                                return Container(); // Return an empty container if reached end
                              }
                            },
                          ),
                        )
                      : Center(child: CircularProgressIndicator()),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
