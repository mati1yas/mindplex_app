import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/authentication/controllers/auth_controller.dart';
import 'package:mindplex/features/drawer/view/widgets/top_user_profile_icon.dart';
import 'package:mindplex/features/drawer/view/widgets/user_info_widget.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';

class LoggedInUserWidget extends StatelessWidget {
  final ProfileController profileController = Get.find();
  final AuthController authController = Get.find();

  LoggedInUserWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 40, bottom: 15),
            child: TopUserProfileIcon(
              profileController: profileController,
              authController: authController,
            ),
          ),
          UserInfoWidget(profileController: profileController),
        ],
      ),
    );
  }
}
