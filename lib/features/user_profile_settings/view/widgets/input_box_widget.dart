import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/user_profile_settings/controllers/settings_controller.dart';

import '../../../../utils/colors.dart';

Widget inputBoxWithLabel(
    BuildContext context,
    bool readOnly,
    TextEditingController? controller,
    TextInputType? inputType,
    String? label,) {
  TextTheme textTheme = Theme.of(context).textTheme;
  Color secondbackgroundColor = Theme.of(context).cardColor;
  IconThemeData icontheme = Theme.of(context).iconTheme;

  SettingsController settingsController = Get.find<SettingsController>();

  return Column(
    children: [
      const SizedBox(height: 20),
      Container(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label??"",
            style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.w500,
                fontSize: 20),
          ),
        ),
      ),
      const SizedBox(height: 5),
      Container(
          decoration: BoxDecoration(
            color: secondbackgroundColor,
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                offset: const Offset(1, 1),
                color: const Color.fromARGB(54, 188, 187, 187),
              )
            ],
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  readOnly: readOnly,
                  controller: controller,
                  keyboardType: inputType,
                  style: textTheme.headline2?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: mainBackgroundColor,
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    errorStyle: const TextStyle(fontSize: 0.01),
                    contentPadding:
                    const EdgeInsets.only(left: 25, top: 10, bottom: 10),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.amber, width: 2.0),
                        borderRadius: BorderRadius.circular(15)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  validator: ((value) {
                    if (label == "Username") {
                      if (value != null && value.length < 3) {
                       return settingsController.setInputError("Username")!.value;
                      } else {
                        settingsController.usernameError.value = "";
                        return null;
                      }
                    } else if (label == "Email") {
                      final emailRegex = RegExp(
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                      if (value!.isEmpty || emailRegex.hasMatch(value) == false) {
                        return settingsController.setInputError("Email")!.value;
                      }
                      else {
                        settingsController.emailError.value = "";
                        return null;
                      }
                    }
                    return null;
                  })))),
    ],
  );
}