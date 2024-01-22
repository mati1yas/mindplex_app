import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/user_profile_settings/services/settings_api_service.dart';
import 'package:mindplex/utils/Toster.dart';

import '../../user_profile_displays/controllers/user_profile_controller.dart';
import '../models/privacy_preference.dart';
import '../models/user_profile.dart';
import '../view/screens/preference.dart';

class PreferenceController extends GetxController{
  // Privacy Preferences
  Rx<PrivacyPreference> agePreference = PrivacyPreference.public.obs;
  Rx<PrivacyPreference> genderPreference = PrivacyPreference.public.obs;
  Rx<PrivacyPreference> educationPreference = PrivacyPreference.public.obs;

  // Theme Preferences
  RxBool lightMode = true.obs;
  RxBool darkMode = false.obs;
  RxBool system = false.obs;

  // Notification Preferences
  RxBool notifyPublications = false.obs;
  RxBool notifyEmail= false.obs;
  RxBool notifyInteraction = false.obs;
  RxBool notifyWeekly = false.obs;
  RxBool notifyUpdates = false.obs;

  final SettingsApiService _apiService = SettingsApiService();
  RxBool isLoading = false.obs;
  RxBool isUpdating = false.obs;

  ProfileController profileController = Get.find<ProfileController>();
  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }


  PrivacyPreference maptoPrivacyPreference(String pref) {

    if (pref == "Private") {
      return PrivacyPreference.private;

    } else if (pref == "Public") {

      return PrivacyPreference.public;
    } else if (pref == "Friends") {
      return PrivacyPreference.friends;
    } else {
      return PrivacyPreference.private;
    }
  }

  String? mapPrivacyPreferenceToString(PrivacyPreference p) {
    if (p == PrivacyPreference.public) {
      return "Public";
    } else if (p == PrivacyPreference.private) {
      return "Private";
    } else if (p == PrivacyPreference.friends) {
      return "Friends";
    }
    return null;
  }

  Future<void> fetchUserProfile() async {
      isLoading.value = true;

    try {
      await profileController.getUserProfile(username: profileController.authenticatedUser.value.username!);
      UserProfile userProfile = profileController.userProfile.value;

      agePreference.value = maptoPrivacyPreference(userProfile.agePreference!);
      genderPreference.value = maptoPrivacyPreference(userProfile.genderPreference!);
      educationPreference.value = maptoPrivacyPreference(userProfile.educationPreference!);
      notifyPublications?.value = userProfile.notifyPublications ?? false;
      notifyEmail?.value = userProfile.notifyFollower ?? false;
      notifyInteraction?.value = userProfile.notifyInteraction ?? false;
      notifyWeekly?.value = userProfile.notifyWeekly ?? false;
      notifyUpdates?.value = userProfile.notifyUpdates ?? false;
      isLoading.value = false;
    } catch (e) {
        isLoading.value = false;
      print('Error fetching user profile: $e');
    }
  }

  Future<void> updateUserProfile() async {

      isUpdating.value = true;
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (context) => Center(
            child: CircularProgressIndicator(color: Colors.green[900]),
          ));

    try {
      print(agePreference);
      UserProfile updatedProfile = UserProfile(
        // Set the updated values for the profile properties
        agePreference: mapPrivacyPreferenceToString(agePreference.value),
        genderPreference: mapPrivacyPreferenceToString(genderPreference.value),
        educationPreference: mapPrivacyPreferenceToString(educationPreference.value),
        notifyPublications: notifyPublications?.value,
        notifyFollower: notifyEmail?.value,
        notifyInteraction: notifyInteraction?.value,
        notifyWeekly: notifyWeekly?.value,
        notifyUpdates: notifyUpdates?.value,
      );
      String updatedValues = await _apiService.updateUserProfile(
        updatedProfile: updatedProfile,
      );
        isUpdating.value = false;
      Navigator.of(Get.context!).pop();
        Toster(message: "Saved",color: Colors.green);
    } catch (e) {
        isUpdating.value = false;
        Navigator.of(Get.context!).pop();
      print('Error updating user profile: $e');

        Toster(message: "Error has occurred",color: Colors.red);
    }
  }

  void toogleColorTheme(String mode, bool newValue) {
    if (mode == "light") {
      if (newValue == false) {
          darkMode.value = true;
          lightMode.value = false;
      } else {
          lightMode.value = true;
          darkMode.value = false;
          system.value = false;
      }
    }
    else if (mode == "dark") {
      if (newValue == false) {
          lightMode.value = true;
          darkMode.value = false;
      } else {

          lightMode.value = false;
          darkMode.value = true;
          system.value = false;

      }
    }
    else if (mode == "system") {
      if (newValue == false) {

          system.value = false;
          lightMode.value = true;

      } else {

          lightMode.value = false;
          darkMode.value = false;
          system.value = true;

      }
    }
  }

  PrivacyPreference getPreference(int value){
    switch(value){
      case 1:
        return agePreference.value;
      case 2:
        return genderPreference.value;
      case 3:
        return educationPreference.value;
        default:
          return agePreference.value;



    }
  }

  void setPreference(int value,PrivacyPreference privacyPreference){

    switch(value){
      case 1:
       agePreference.value = privacyPreference;
       break;
      case 2:
        genderPreference.value = privacyPreference;
        break;
      case 3:
        educationPreference.value = privacyPreference;
        break;

    }
  }
}