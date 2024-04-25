import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';
import 'package:mindplex/features/user_profile_settings/controllers/recommendation_controller.dart';
import 'package:mindplex/features/user_profile_settings/view/widgets/recommendation_slider_widget.dart';

import '../../../../utils/colors.dart';
import '../widgets/button_widget.dart';

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({Key? key}) : super(key: key);

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  RecommendationController recommendationController =
      Get.put(RecommendationController());
  ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    recommendationController
        .fetchUserInfo(profileController.authenticatedUser.value.username!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => recommendationController.isLoading.value
        ? Scaffold(
            backgroundColor: mainBackgroundColor,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: mainBackgroundColor,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Here, you can set the intensity of our recommendation engine's parameters. "
                        "Mindplex empowers you to own your own model, and we recommend content based on a model of your choice. "
                        "Edit your model here, and enjoy our content from the read pages.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                  sliderWidget("Popularity", 1),
                  sliderWidget("Pattern", 2),
                  sliderWidget("High Quality", 3),
                  sliderWidget("Random", 4),
                  sliderWidget("Timeliness", 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Center(
                      child: buildButton("Save", (() async {
                        recommendationController.updateUserProfile();
                      }), Color.fromARGB(255, 0, 207, 195), true, context),
                    ),
                  ),
                ],
              ),
            ),
          ));
  }
}
