import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/user_profile_settings/services/settings_api_service.dart';
import 'package:mindplex/services/api_services.dart';
import 'package:mindplex/utils/Toster.dart';

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
          Toster(message: "Password successfully changed",color: Colors.green),
      }
      else{
          Toster(message: "Some error occurred, please try again",color: Colors.red),
    }
    });

    } catch (e) {
      isUpdating.value = false;
      Navigator.pop(Get.context!);
      Toster(message: "Some error occurred, check your connection",color: Colors.red);
      return ;
    }
  }
  void setIsSaved(bool value){
    isSaved.value = value;
  }
}