import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/drawer/view/widgets/top_user_profile_icon.dart';

import '../../../authentication/controllers/auth_controller.dart';
import '../../../blogs/controllers/blogs_controller.dart';
import '../../../bottom_navigation_bar/controllers/bottom_page_navigation_controller.dart';
import '../../../mindplex_profile/about_mindplex/view/screens/about_mindplex.dart';
import '../../../mindplex_profile/moderators/view/screens/moderators_page.dart';
import '../../../user_profile_displays/controllers/user_profile_controller.dart';
import '../../../../routes/app_routes.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({
    super.key,
  });
  ProfileController profileController = Get.find();
  BlogsController blogsController = Get.find();
  PageNavigationController pageNavigationController = Get.find();
  AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return BackdropFilter(
      blendMode: BlendMode.srcOver,
      filter: ImageFilter.blur(
          sigmaX: 13.0, sigmaY: 13.0, tileMode: TileMode.clamp),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF062f46), Color(0xFF1d253d)],
        )),
        child: ListView(
          padding: EdgeInsets.only(top: 20, left: 20),
          children: [
            Obx(
              () => authController.isGuestUser.value
                  ? Column(
                      children: [
                        Container(
                          child: Center(
                            child: Text(
                              "Hello Guest , 👋",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 30,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1.4,
                          color: Colors.white,
                        )
                      ],
                    )
                  : Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 40, bottom: 15),
                            child: TopUserProfileIcon(
                                profileController: profileController,
                                authController: authController),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profileController
                                          .authenticatedUser.value.firstName ??
                                      " " +
                                          '${profileController.authenticatedUser.value.lastName}' ??
                                      " ",
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  profileController
                                          .authenticatedUser.value.username ??
                                      " ",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          profileController
                                              .authenticatedUser.value.friends
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: width * 0.04,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          " Friends",
                                          style: TextStyle(
                                              fontSize: width * 0.04,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          profileController.authenticatedUser
                                              .value.followings
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: width * 0.04,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          " Following",
                                          style: TextStyle(
                                              fontSize: width * 0.04,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          profileController
                                              .authenticatedUser.value.followers
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: width * 0.04,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          " Followers",
                                          style: TextStyle(
                                              fontSize: width * 0.04,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
              margin: const EdgeInsets.only(right: 40),
              decoration: const BoxDecoration(
                  color: Color(0xFF0f3e57),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 25,
                ),
                title: const Text(
                  'Profile',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                onTap: () {
                  if (authController.isGuestUser.value) {
                    authController.guestReminder(context);
                  } else {
                    Navigator.of(context).pop();
                    Get.toNamed(AppRoutes.profilePage,
                        parameters: {"me": "me", "username": ""});
                  }

                  // ...
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: const Icon(
                Icons.upgrade_rounded,
                size: 25,
                color: Color(0xFFf55586),
              ),
              title: const Text(
                'Upgrade',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFf55586)),
              ),
              onTap: () {
                // ...
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.description_outlined,
                size: 25,
                color: Colors.white,
              ),
              title: const Text(
                'Read',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onTap: () {
                blogsController.filterBlogsByPostType(postFormat: 'text');
                Navigator.pop(context);
                pageNavigationController.navigatePage(0);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.videocam,
                size: 25,
                color: Colors.white,
              ),
              title: const Text(
                'Watch',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onTap: () {
                blogsController.filterBlogsByPostType(postFormat: 'video');

                pageNavigationController.navigatePage(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.headphones,
                size: 25,
                color: Colors.white,
              ),
              title: const Text(
                'Listen',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onTap: () {
                blogsController.filterBlogsByPostType(postFormat: 'audio');
                Navigator.pop(context);
                pageNavigationController.navigatePage(0);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.new_label_rounded,
                size: 25,
                color: Colors.white,
              ),
              title: const Text(
                'News',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onTap: () {
                blogsController.loadArticles();
                Navigator.pop(context);
                pageNavigationController.navigatePage(0);
                // ...
              },
            ),
            ListTile(
              leading: const Icon(
                FontAwesome.cube,
                size: 25,
                color: Colors.white,
              ),
              title: const Text(
                'Topics',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onTap: () {
                blogsController.loadTopics();
                Navigator.pop(context);
                pageNavigationController.navigatePage(0);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.groups,
                size: 25,
                color: Colors.white,
              ),
              title: const Text(
                'Community Content',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onTap: () {
                blogsController.loadCommunityContents();
                Navigator.pop(context);
                pageNavigationController.navigatePage(0);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.help_outline,
                size: 25,
                color: Colors.white,
              ),
              title: const Text(
                'FAQ',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.people_alt_sharp,
                size: 25,
                color: Colors.white,
              ),
              title: const Text(
                'Moderators',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Get.to(() => ModeratorsPage());
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.people_alt_sharp,
                size: 25,
                color: Colors.white,
              ),
              title: const Text(
                'About Us',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Get.to(() => AboutMindPlex());
              },
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "© 2023 MindPlex. All rights reserved",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  child: Icon(
                    Icons.settings,
                    size: 32,
                    color: Colors.white,
                  ),
                  onTap: () {
                    if (authController.isGuestUser.value) {
                      authController.guestReminder(context);
                    } else {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.settingsPage);
                    }
                  },
                ),
                SizedBox(
                  width: 15,
                )
              ],
            ),
            SizedBox(
              height: 60,
            )
          ],
        ),
      ),
    );
  }
}
