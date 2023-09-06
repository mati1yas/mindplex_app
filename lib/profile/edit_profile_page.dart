import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mindplex_app/profile/user_profile_controller.dart';
import 'package:mindplex_app/routes/app_routes.dart';

import '../auth/auth_controller/auth_controller.dart';
import '../utils/colors.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  AuthController authController = Get.put(AuthController());

  ProfileController profileController = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      body: Column(
          children: [
      Container(
      margin: const EdgeInsets.only(top: 40, left: 5, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CupertinoButton(
            padding: const EdgeInsets.all(0),
            child: Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: 35,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Get.toNamed(AppRoutes.settingsPage);
            },
          ),
          Text(
            'Edit Profile',
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(color: Colors.lightBlue[100], borderRadius: BorderRadius.circular(100)),
            child: CupertinoButton(
              padding: const EdgeInsets.only(left: 3),
              child: const Icon(
                Icons.logout,
                color:const Color.fromARGB(255, 2, 31, 31),
                size: 16,
              ),
              onPressed: () {
              },
            ),
          ),
        ],
      ),
    ),]));
  }
}
