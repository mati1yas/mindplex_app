import 'package:flutter/material.dart';
import 'package:mindplex/profile/user_profile_controller.dart';

class UserInterest extends StatelessWidget {
  const UserInterest({
    super.key,
    required this.profileController,
  });

  final ProfileController profileController;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 35,
        child: ListView.builder(
            itemCount: profileController.userProfile.value.interests!.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, index) {
              return Container(
                  margin: const EdgeInsets.only(left: 5, right: 5),
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                      // color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white)),
                  child: Center(
                    child: Text(
                      profileController.userProfile.value.interests![index],
                      style: TextStyle(color: Colors.white),
                    ),
                  ));
            }));
  }
}
