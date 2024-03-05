import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/routes/app_routes.dart';

import '../../../authentication/controllers/auth_controller.dart';
import '../../../user_profile_displays/controllers/user_profile_controller.dart';
import '../../../../utils/constatns.dart';

class TopUserProfileIcon extends StatelessWidget {
  const TopUserProfileIcon({
    super.key,
    required this.profileController,
    required this.authController,
    this.openDrawer = true,
    this.radius = 27,
  });

  final ProfileController profileController;
  final AuthController authController;
  final bool openDrawer;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // if draawer is already open it means we should navigate to profile page.
        if (Keys.globalkey.currentState!.isDrawerOpen) if (authController
            .isGuestUser.value) {
          authController.guestReminder(context);
        } else {
          Get.toNamed(AppRoutes.profilePage,
              parameters: {"me": "me", "username": ""});
        }

//  if drawer is not opened we open it
        if (openDrawer) {
          Keys.globalkey.currentState!.openDrawer();
        }
      },
      child: Obx(() => CircleAvatar(
            radius: radius,
            backgroundImage: NetworkImage(authController.isGuestUser.value
                ? authController.guestUserImage.value
                : profileController.authenticatedUser.value.image ??
                    "https://secure.gravatar.com/avatar/44cb6ed8fa0451a09a6387dc8bf2533a?s=260&d=mm&r=g"),
          )),
    );
  }
}
