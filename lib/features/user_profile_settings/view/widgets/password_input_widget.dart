

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/user_profile_settings/controllers/settings_controller.dart';

import '../../../../utils/colors.dart';

Widget passwordInput(
    BuildContext context,
    TextEditingController controller,
    String? hint,
    String? type,
    FocusNode focus,
    FocusNode? focusNext,
    String? confirmPassword,
    VoidCallback onTap) {
  TextTheme textTheme = Theme.of(context).textTheme;
  Color secondbackgroundColor = Theme.of(context).cardColor;
  SettingsController settingsController = Get.find<SettingsController>();

  String? newPasswordError;
  String? confirmPasswordError;

  return Container(
      height: 48,
      margin: const EdgeInsets.only(top: 10),
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
          focusNode: focus,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller,
          obscureText:
          type == "new" ? !settingsController.oldPasswordVisible.value : !settingsController.confirmPasswordVisible.value,
          style: type == "new"
              ? settingsController.oldPasswordVisible.value
              ? textTheme.displayMedium?.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.white)
              : TextStyle(color: Colors.amber, fontSize: 30)
              :
          settingsController.confirmPasswordVisible.value
              ? textTheme.displayMedium?.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.white)
              : TextStyle(
              color: Colors.amber,
              fontSize: 30), //font size to be changed later on
          textAlignVertical: TextAlignVertical.center,
          cursorColor: Colors.blue,
          decoration: InputDecoration(
            filled: true,
            fillColor: mainBackgroundColor,
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(15.0),
            ),
            errorStyle: const TextStyle(fontSize: 0.01),
            contentPadding: type == "new"
                ? settingsController.oldPasswordVisible.value
                ? EdgeInsets.only(left: 10, top: 10, bottom: 10)
                : EdgeInsets.only(left: 5, bottom: 5)
                : settingsController.confirmPasswordVisible.value
                ? EdgeInsets.only(left: 10, top: 10, bottom: 10)
                : EdgeInsets.only(left: 5, bottom: 5),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(15.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.amber, width: 2.0),
              borderRadius: BorderRadius.circular(15.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(15.0),
            ),
            border: InputBorder.none,
            suffixIcon: IconButton(
              onPressed: onTap,
              icon: Icon(
                type == "new"
                    ? settingsController.oldPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off
                    : settingsController.confirmPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: focus.hasFocus ? Colors.blue : Colors.amber,
                size: 30,
              ), //
            ),
          ),
          onFieldSubmitted: ((value) {
            if (type == "new") {
              FocusScope.of(context).requestFocus(focusNext);
            } else {
              FocusScope.of(context).unfocus();
            }
          }),
          validator: ((value) {
            if (type == "new") {
              if (value != null && value.length < 8) {
                newPasswordError = "Must be at least 8 characters";
                return newPasswordError;
              } else if (!value!.contains(RegExp(r'[a-z]'))) {
                newPasswordError = "Must have at least 1 lower case alphabet";
                return newPasswordError;
              } else if (!value!.contains(RegExp(r'[A-Z]'))) {
                newPasswordError = "Must have at least 1 upper case alphabet";
                return newPasswordError;
              } else if (!value!.contains(RegExp(r'[0-9]'))) {
                newPasswordError = "Must have at least 1 number";
                return newPasswordError;
              } else {
                newPasswordError = null;
                return null;
              }
            } else if (type == "confirm") {
              if (value != null && value.length < 8) {
                confirmPasswordError = "Must be at least 8 characters";
                return confirmPasswordError;
              } else if (value != confirmPassword) {
                confirmPasswordError = "Passwords do not match";
                return confirmPasswordError;
              } else {
                confirmPasswordError = null;
                return null;
              }
            } else {
              return null;
            }
          }),
        ),
      ));
}