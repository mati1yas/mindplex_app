import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/user_profile_settings/controllers/recommendation_controller.dart';

Widget sliderWidget(String label,int value){

  RecommendationController recommendationController = Get.find<RecommendationController>();
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 10),
        child: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: TextStyle(
                color: Color.fromARGB(255, 255, 226, 121),
                fontWeight: FontWeight.w400,
                fontSize: 20),
          ),
        ),
      ),
      Slider(
        thumbColor: Color.fromARGB(255, 0, 207, 195),
        activeColor: Color.fromARGB(255, 0, 207, 195),
        value: recommendationController.editedSeekbars.isEmpty && recommendationController.getSliderValue(value) == 0.0
            ? 50.0
            : recommendationController.getSliderValue(value),
        max: 100,
        divisions: 100,
        label: recommendationController.getSliderValue(value).round().toString(),
        onChanged: (newValue) => recommendationController.updateSeekBarValue(value, newValue),
      ),
      Center(
          child: Text(
            (recommendationController.editedSeekbars.isEmpty && recommendationController.getSliderValue(value) == 0.0
                ? " "
                : recommendationController.getSliderValue(value).round().toString().toString()) +
                "%",
            style: TextStyle(
                color: Color.fromARGB(255, 255, 226, 121),
                fontWeight: FontWeight.w500,
                fontSize: 18),
          )),
    ],
  );
}