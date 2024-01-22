import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../authentication/controllers/auth_controller.dart';
import '../../../user_profile_displays/controllers/user_profile_controller.dart';
import '../../../../utils/constatns.dart';

class TopUserProfileIcon extends StatelessWidget {
  const TopUserProfileIcon({
    super.key,
    required this.profileController,
    required this.authController,
    this.openDrawer = true,
  });

  final ProfileController profileController;
  final AuthController authController;
  final bool openDrawer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {if (openDrawer) Keys.globalkey.currentState!.openDrawer()},
      child: Obx(() => CircleAvatar(
            radius: 27,
            backgroundImage: NetworkImage(authController.isGuestUser.value
                ? authController.guestUserImage.value
                : profileController.authenticatedUser.value.image ??
                    "https://secure.gravatar.com/avatar/44cb6ed8fa0451a09a6387dc8bf2533a?s=260&d=mm&r=g"),
          )),
    );
  }
}
