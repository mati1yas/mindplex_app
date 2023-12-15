import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth/auth_controller/auth_controller.dart';
import '../profile/user_profile_controller.dart';
import '../utils/constatns.dart';

class TopUserProfileIcon extends StatelessWidget {
  const TopUserProfileIcon({
    super.key,
    required this.profileController,
    required this.authController,
  });

  final ProfileController profileController;
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {Keys.globalkey.currentState!.openDrawer()},
      child: Obx(
        () => Container(
          height: 40,
          width: 40,
          margin: EdgeInsets.only(left: 40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xFF0c2b46),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(authController.isGuestUser.value
                  ? authController.guestUserImage.value
                  : profileController.authenticatedUser.value.image ?? ""),
            ),
          ),
        ),
      ),
    );
  }
}
