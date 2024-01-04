import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/drawer/controller/drawer_controller.dart';
import 'package:mindplex/features/drawer/model/drawer_items.dart';
import 'package:mindplex/features/drawer/model/drawer_model.dart';
import 'package:mindplex/features/drawer/model/drawer_types.dart';
import 'package:mindplex/features/drawer/view/widgets/drawer_button.dart';
import 'package:mindplex/features/drawer/view/widgets/top_user_profile_icon.dart';

import '../../../authentication/controllers/auth_controller.dart';
import '../../../blogs/controllers/blogs_controller.dart';
import '../../../bottom_navigation_bar/controllers/bottom_page_navigation_controller.dart';
import '../../../user_profile_displays/controllers/user_profile_controller.dart';
import '../../../../routes/app_routes.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({
    super.key,
  });
  final ProfileController profileController = Get.find();
  final BlogsController blogsController = Get.find();
  final PageNavigationController pageNavigationController = Get.find();
  final AuthController authController = Get.find();

  final DrawerButtonController _drawerButtonController = Get.find();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final List<DrawerModel> drawers = DrawerItems.drawers;
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
                          height: 190,
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
                      height: 200,
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
                                          '${profileController.authenticatedUser.value.lastName}',
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
            DrawerItemButton(
              icon: Icons.person,
              drawerType: _drawerButtonController.currentDrawerType.value,
              currentDrawerType: DrawerType.profile,
              drawerTitle: 'Profile',
              onTap: () {
                if (authController.isGuestUser.value) {
                  authController.guestReminder(context);
                } else {
                  Navigator.of(context).pop();
                  Get.toNamed(AppRoutes.profilePage,
                      parameters: {"me": "me", "username": ""});
                  _drawerButtonController.changeDrawerType(DrawerType.profile);
                }
              },
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: drawers.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return DrawerItemButton(
                    icon: drawers[index].icon,
                    drawerType: drawers[index].drawerType,
                    currentDrawerType:
                        _drawerButtonController.currentDrawerType.value,
                    drawerTitle: drawers[index].drawerName,
                    color: drawers[index].color,
                    onTap: () {
                      _drawerButtonController.navigateToPage(drawers[index]);
                    },
                  );
                }),
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
