import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/user_profile_settings/controllers/preference_controller.dart';
import 'package:mindplex/features/user_profile_settings/view/screens/preference.dart';

import '../../models/privacy_preference.dart';

Widget labeledRadioButton(String label,PrivacyPreference privacyPreference,int value){
  PreferenceController preferenceController = Get.find();
  return ListTile(
    title: Text(
      label,
      style: TextStyle(color: Colors.white),
    ),
    leading: Radio<PrivacyPreference>(
      value: privacyPreference,
      groupValue: preferenceController.getPreference(value),
      onChanged: (PrivacyPreference? pref) {
         preferenceController.setPreference(value, pref!);
      },
      fillColor: MaterialStateColor.resolveWith(
              (states) => Colors.pinkAccent),
    ),
  );
}