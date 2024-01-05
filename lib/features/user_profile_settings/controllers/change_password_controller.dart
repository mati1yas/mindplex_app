import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/user_profile_settings/services/settings_api_service.dart';
import 'package:mindplex/services/api_services.dart';

class PasswordController extends GetxController{

  RxBool oldPasswordVisible = false.obs;
  RxBool confirmPasswordVisible = false.obs;
  RxString newPassword = "".obs;
  RxString confirmPassword = "".obs;
  RxString? newPasswordError = "".obs;
  RxString? confirmPasswordError = "".obs;
  RxBool isUpdating = false.obs;
  RxBool isSaved = false.obs;

  SettingsApiService apiService = SettingsApiService();

  void  changePasswordVisibility(int value){
    if(value == 0){
      oldPasswordVisible.value = !oldPasswordVisible.value;
    }
    else if(value == 1){
      confirmPasswordVisible.value = ! confirmPasswordVisible.value;
    }
  }
  String? setError(bool isNewPassword,String? errorText){
    if(isNewPassword){
      if(errorText == null){
        newPasswordError = null;
        return errorText;
      }
      newPasswordError?.value = errorText;
      return errorText;
    }
    else{
      if(errorText == null){
        confirmPasswordError = null;
        return errorText;
      }
      confirmPasswordError?.value = errorText;
      return errorText;
    }
  }
  void saveNewPassword(String password) async {
    isUpdating.value = true;
    try {
      await apiService.changePassword(password).then((value) => {
        isUpdating.value = false,
        Navigator.pop(Get.context!),
      if(value){
      Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
        titleSize: 20,
        messageSize: 17,
        messageColor: Colors.white,
        backgroundColor: Colors.green,
        borderRadius: BorderRadius.circular(8),
        message: "Password Changed",
        duration: const Duration(seconds: 2),
      ).show(Get.context!),
      }
      else{
        Flushbar(
          flushbarPosition: FlushbarPosition.BOTTOM,
          margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
          titleSize: 20,
          messageSize: 17,
          messageColor: Colors.white,
          backgroundColor: Colors.red,
          borderRadius: BorderRadius.circular(8),
          message: "Some error occurred, please try again",
          duration: const Duration(seconds: 2),
        ).show(Get.context!),
    }
    });

    } catch (e) {
      isUpdating.value = false;
      Navigator.pop(Get.context!);
      Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
        titleSize: 20,
        messageSize: 17,
        messageColor: Colors.white,
        backgroundColor: Colors.red,
        borderRadius: BorderRadius.circular(8),
        message: "Some error occurred, check your connection",
        duration: const Duration(seconds: 2),
      ).show(Get.context!);
      return ;
    }
  }
  void setIsSaved(bool value){
    isSaved.value = value;
  }
}