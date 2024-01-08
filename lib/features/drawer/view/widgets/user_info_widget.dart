import 'package:flutter/material.dart';
import 'package:mindplex/utils/colors.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';
import 'package:mindplex/utils/number_coverter.dart';

class UserInfoWidget extends StatelessWidget {
  final ProfileController profileController;

  const UserInfoWidget({
    super.key,
    required this.profileController,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    final String _firstName =
        profileController.authenticatedUser.value.firstName ?? "";
    final String _lastName =
        profileController.authenticatedUser.value.lastName ?? "";
    final String _fullUserName = "$_firstName  $_lastName";

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _fullUserName,
            style: TextStyle(
              fontSize: 20,
              color: white,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            profileController.authenticatedUser.value.username ?? " ",
            style: TextStyle(
              fontSize: 20,
              color: userNameColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Row(
                children: [
                  Text(
                    formatNumber(
                      profileController.authenticatedUser.value.friends ?? 0,
                    ),
                    style: TextStyle(
                      fontSize: width * 0.04,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    " Friends",
                    style:
                        TextStyle(fontSize: width * 0.04, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(
                width: 5,
              ),
              Row(
                children: [
                  Text(
                    formatNumber(
                      profileController.authenticatedUser.value.followings ?? 0,
                    ),
                    style: TextStyle(
                        fontSize: width * 0.04,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " Following",
                    style:
                        TextStyle(fontSize: width * 0.04, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(
                width: 5,
              ),
              Row(
                children: [
                  Text(
                    formatNumber(
                      profileController.authenticatedUser.value.followers ?? 0,
                    ),
                    style: TextStyle(
                        fontSize: width * 0.04,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " Followers",
                    style:
                        TextStyle(fontSize: width * 0.04, color: Colors.grey),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
