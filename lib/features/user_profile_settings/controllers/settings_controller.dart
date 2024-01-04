import 'package:get/get.dart';
import 'package:mindplex/features/user_profile_settings/models/user_profile.dart';
import 'package:mindplex/features/user_profile_settings/services/settings_api_service.dart';

class SettingsController extends GetxController{
  RxBool isLoading = true.obs;
  RxString username = "".obs;
  RxString? usernameError = "".obs;
  RxString email = "".obs;
  RxString? emailError = "".obs;
  RxBool isSaved = false.obs;

  RxBool oldPasswordVisible = false.obs;
  RxBool confirmPasswordVisible = false.obs;



  final apiService = SettingsApiService().obs;

  void fetchUserInfo(String name) async {
    isLoading.value = true;
     print(name);
    UserProfile res = await apiService.value.fetchUserProfile(userName: name);
    print(res.username);
    username.value = res.username??"abr";
    isLoading.value = false;
    update();
  }

  RxString? setInputError(String inputLabel){
    if(inputLabel == "Username"){
      usernameError =  "Please enter your user name (Minimum of 3 characters)".obs;
      return usernameError;
    }
    else if(inputLabel == "Email"){
      emailError =  "Please enter a valid email address (ex. abc@gmail.com)".obs;
      return emailError;
    }
  }

  void  changePasswordVisibility(int value){
    if(value == 0){
      oldPasswordVisible.value = !oldPasswordVisible.value;
    }
    else if(value == 1){
      confirmPasswordVisible.value = ! confirmPasswordVisible.value;
    }
  }
}