import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';
import 'package:mindplex/features/user_profile_settings/models/user_profile.dart';
import 'package:mindplex/features/user_profile_settings/services/settings_api_service.dart';

import '../../../utils/Toster.dart';
import '../../../utils/network/connection-info.dart';

class SettingsController extends GetxController{

  RxBool isLoading = true.obs;
  RxString username = "".obs;
  RxString usernameError = "".obs;
  RxString email = "".obs;
  RxString emailError = "".obs;
  RxBool isSaved = false.obs;
  RxBool isConnected = true.obs;

  @override
  void onInit() {
    fetchUserInfo(profileController.authenticatedUser.value.username!);
    super.onInit();
  }





  final apiService = SettingsApiService().obs;
  ProfileController profileController = Get.find();
  ConnectionInfoImpl connectionChecker = Get.find();


  void fetchUserInfo(String name) async {
      isLoading.value = true;
      print(name);
      await profileController.getUserProfile(username: name);
      username.value = profileController.userProfile.value.username!;
      isLoading.value = false;
      update();
    }

  RxString? setInputError(String inputLabel){
    if(inputLabel == "Username"){
      usernameError.value =  "Please enter your user name (Minimum of 3 characters)";
      return usernameError;
    }
    else if(inputLabel == "Email"){
      emailError =  "Please enter a valid email address (ex. abc@gmail.com)".obs;
      return emailError;
    }
  }

}