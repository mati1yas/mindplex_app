import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mindplex/features/authentication/controllers/auth_controller.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';
import 'package:mindplex/features/user_profile_displays/view/widgets/user_profile_image_widget.dart';
import 'package:mindplex/routes/app_routes.dart';

class ProfileTopSection extends StatelessWidget {
  const ProfileTopSection({
    super.key,
    required this.userProfileController,
    required this.context,
    required this.authController,
    required this.me,
  });

  final ProfileController userProfileController;
  final BuildContext context;
  final AuthController authController;
  final bool me;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, top: 20),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          UserProfileImage(
              context: context,
              profileController: userProfileController,
              me: me),
          Positioned(
            top: 0,
            left: 5,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 5,
            child: PopupMenuButton(
                color: Colors.white,
                iconColor: Colors.white,
                itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () {
                          authController.logout();
                          // Navigator.of(context).pop();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.logout),
                            Text("Logout"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          Get.toNamed(AppRoutes.settingsPage);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.info),
                            Text("Edit Profile"),
                          ],
                        ),
                      ),
                    ]),
          ),
        ],
      ),
    );
  }
}
