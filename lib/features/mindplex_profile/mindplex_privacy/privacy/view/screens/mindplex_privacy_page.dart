import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/blogs/view/widgets/blog_content_display.dart';
import 'package:mindplex/features/drawer/controller/drawer_controller.dart';
import 'package:mindplex/features/mindplex_profile/mindplex_privacy/privacy/controllers/privacy_controller.dart';
import 'package:mindplex/utils/custom_app_bar.dart';

class MindplexPrivacy extends StatelessWidget {
  MindplexPrivacy({super.key});
  DrawerButtonController drawerButtonController = Get.find();
  PrivacyController privacyController = Get.put(PrivacyController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color.fromARGB(255, 7, 50, 64),
      body: Column(
        children: [
          CustomAppBar(
              height: height,
              width: width,
              drawerButtonController: drawerButtonController,
              pageName: "Privacy"),
          Container(
            height: height * 0.86,
            child: ListView(
              shrinkWrap: true,
              children: [
                BlogContentDisplay(
                  data: privacyController.contents,
                  padding: 8,
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
