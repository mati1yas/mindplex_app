import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mindplex_app/auth/auth.dart';
import 'package:mindplex_app/services/local_storage.dart';

import '../../services/auth_service.dart';

class AuthController extends GetxController {
  final authService = AuthService().obs;
  final localStorage =
      LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
  final RxBool isAuthenticated = false.obs;
  final RxBool isRegistered = false.obs;
  final RxBool isVerified = false.obs;

  void checkAuthentication() async {
    final hasToken = await localStorage.value.readFromStorage('Token');

    if (hasToken != '') {
      isAuthenticated.value = true;
    } else {
      isAuthenticated.value = false;
    }
  }

  void checkFirstTime() async {}

  void logout() {
    localStorage.value.deleteFromStorage("Token");
    isAuthenticated.value = false;
    Get.to(() => AuthPage());
  }

  Future<void> loginUser(
      {required String email,
      required String password,
      required String loginType}) async {
    try {
      final userData = await authService.value
          .loginUser(email: email, password: password, loginType: loginType);
      localStorage.value.writeToStorage("Token", userData.token.toString());

      localStorage.value.storeUserInfo(
          email: userData.userEmail.toString(),
          image: userData.image.toString(),
          userDisplayName: userData.userDisplayName.toString(),
          username: userData.username.toString(),
          firstName: userData.firstName.toString(),
          lastName: userData.lastName.toString(),
          userNiceName: userData.userNicename.toString());
      isAuthenticated.value = true;
    } catch (e) {
      isAuthenticated.value = false;
    }
  }

  Future<void> register(
      {required String email,
      required String firstName,
      required String lastName,
      required String password}) async {
    try {
      String statusCode = await authService.value.register(
          email: email,
          firstName: firstName,
          lastName: lastName,
          password: password);

      if (statusCode == '200') {
        isRegistered.value = true;
      } else {
        isRegistered.value = false;
      }
    } catch (e) {
      isRegistered.value = false;
    }
  }
}
