import 'package:flutter/material.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';

class UserProfileImage extends StatelessWidget {
  const UserProfileImage({
    super.key,
    required this.context,
    required this.profileController,
    required this.me,
  });

  final BuildContext context;
  final ProfileController profileController;
  final bool me;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.green,
      radius: MediaQuery.of(context).size.width * 0.25,
      backgroundImage: NetworkImage(
        me
            ? profileController.authenticatedUser.value.image ??
                "assets/images/profile.PNG"
            : profileController.userProfile.value.avatarUrl ??
                "assets/images/profile.PNG",
      ),
    );
  }
}
