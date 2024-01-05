import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';

import '../../../utils/Toster.dart';
import '../models/user_profile.dart';
import '../services/settings_api_service.dart';

class RecommendationController extends GetxController{

  RxDouble popularity = 0.0.obs;
  RxDouble pattern = 0.0.obs;
  RxDouble highQuality = 0.0.obs;
  RxDouble random = 0.0.obs;
  RxDouble timeliness = 0.0.obs;
  RxBool isLoading = false.obs;
  RxBool isUpdating = false.obs;

  RxList<int> editedSeekbars = <int>[].obs;
  RxInt lastEditedSeekbar = 0.obs;


  final apiService = SettingsApiService().obs;
  ProfileController profileController = Get.find<ProfileController>();

  @override
  void onInit() {
    super.onInit();
    fetchUserInfo(profileController.authenticatedUser.value.username!);
  }

  void fetchUserInfo(String name) async {
    isLoading.value = true;
    UserProfile res = await apiService.value.fetchUserProfile(userName: name);
    popularity.value = res.recPopularity!.toDouble();
    pattern.value = res.recPattern!.toDouble();
    highQuality.value = res.recQuality!.toDouble();
    random.value = res.recRandom!.toDouble();
    timeliness.value = res.recTimeliness!.toDouble();
    isLoading.value = false;
    update();
  }

  void updateUserProfile() async {
    if (await checkSeekBarValues() == false) {
      Toster(message: "Sum of recommendation values must be below a hundred",color: Colors.red);
    } else {
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (context) => Center(
            child: CircularProgressIndicator(color: Colors.green[900]),
          ));
     isUpdating.value = true;
      try {
        UserProfile updatedProfile = UserProfile(
          recPopularity: popularity.round(),
          recPattern: pattern.round(),
          recQuality: highQuality.round(),
          recRandom: random.round(),
          recTimeliness: timeliness.round(),
        );
        String? updatedValues = await apiService.value.updateUserProfile(
          updatedProfile: updatedProfile,
        );
        print(updatedValues);
        isUpdating.value = false;
        Navigator.of(Get.context!).pop();
        Toster(message: "Saved",color: Colors.green);
      } catch (e) {
        isUpdating.value = false;
        print('Error updating user profile: $e');
      }
    }
  }

  void updateSeekBarValue(int seekBarIndex, double newValue) {

      double totalAmount = 0;
      for (int i = 0; i < editedSeekbars.length; i++) {
        if (editedSeekbars[i] == seekBarIndex) {
          continue;
        }
        totalAmount += getSliderValue(editedSeekbars[i]);
      }
      double remainingAmount = 100 - totalAmount - newValue;
      int length = 0;
      if (editedSeekbars.contains(seekBarIndex) &&
          lastEditedSeekbar == seekBarIndex) {
        length = editedSeekbars.length - 1;
      } else {
        length = editedSeekbars.length;
      }
      double newValueForOthers = remainingAmount / (4 - length);
      if (newValueForOthers > 0 || newValueForOthers < 100) {
        lastEditedSeekbar.value = seekBarIndex;
        if (!editedSeekbars.contains(seekBarIndex)) {
          editedSeekbars.add(seekBarIndex);
        }
        for (int i = 1; i < 6; i++) {
          if (i != seekBarIndex && !editedSeekbars.contains(i)) {
            setSeekBarValue(i, newValueForOthers);
          }
        }
        setSeekBarValue(seekBarIndex, newValue);
      }
      popularity.value = popularity.value.clamp(0, 100);
      pattern.value = pattern.value.clamp(0, 100);
      highQuality.value = highQuality.value.clamp(0, 100);
      random.value = random.value.clamp(0, 100);
      timeliness.value = timeliness.value.clamp(0, 100);
  }

  double getSliderValue(int seekBarIndex) {
    switch (seekBarIndex) {
      case 1:
        return popularity.value;
      case 2:
        return pattern.value;
      case 3:
        return highQuality.value;
      case 4:
        return random.value;
      case 5:
        return timeliness.value;
      default:
        return 0.0;
    }
  }

  void setSeekBarValue(int seekBarIndex, double value) {
    switch (seekBarIndex) {
      case 1:
          popularity.value = value;
        break;
      case 2:
          pattern.value = value;
        break;
      case 3:
          highQuality.value = value;
        break;
      case 4:
          random.value = value;
        break;
      case 5:
          timeliness.value = value;
        break;
    }
  }

  Future<bool> checkSeekBarValues() async {
    int totalValues = 0;
    for (int i = 1; i < 6; i++) {
      totalValues += getSliderValue(i).round();
    }
    print(totalValues);
    if (totalValues == 100) {
      return true;
    } else if (totalValues == 99) {
        popularity.value += 0.5;
      return checkSeekBarValues();
    } else if (totalValues == 101) {
        popularity.value -= 0.5;
      return checkSeekBarValues();
    } else if (totalValues == 102) {
        popularity.value -= 1;
      return checkSeekBarValues();
    }
    return false;
  }
}