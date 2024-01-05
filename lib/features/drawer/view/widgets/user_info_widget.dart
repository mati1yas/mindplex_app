import 'package:flutter/material.dart';
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
    final String _firstName = "Gedion";
    final String _lastName = "Someone";
    final String _fullUserName = "$_firstName  $_lastName";

    return Container(
      margin: const EdgeInsets.only(left: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_fullUserName),
          SizedBox(
            height: 10,
          ),
          Text(
            "primequantuM4",
            // profileController.authenticatedUser.value.username ?? " ",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
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
                    formatNumber(123),
                    // profileController.authenticatedUser.value.friends
                    //     .toString(),
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
                    formatNumber(100000),
                    // profileController.authenticatedUser.value.followings
                    // .toString(),
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
                    formatNumber(1000000),
                    // profileController.authenticatedUser.value.followers
                    //     .toString(),
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
