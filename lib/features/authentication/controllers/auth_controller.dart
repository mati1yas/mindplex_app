import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/authentication/view/screens/auth.dart';
import 'package:mindplex/routes/app_routes.dart';
import 'package:mindplex/features/local_data_storage/local_storage.dart';

import '../api_service/auth_service.dart';

class AuthController extends GetxController {
  final authService = AuthService().obs;
  Rx<LocalStorage> localStorage =
      LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
  final RxBool isAuthenticated = false.obs;
  final RxBool isRegistered = false.obs;
  final RxBool isVerified = false.obs;
  final RxString statusMessage = ''.obs;
  final RxString guestUserImage = ''.obs;
  final RxBool isGuestUser = false.obs;

  void checkAuthentication() async {
    final hasToken = await localStorage.value.readFromStorage('Token');

    if (hasToken != '') {
      try {
        bool authstatus = await refreshTokenIfNeeded();
        if (authstatus) {
          isAuthenticated.value = true;
        } else {
          isAuthenticated.value = false;
        }
      } catch (e) {
        isAuthenticated.value = false;
      }
    } else {
      isAuthenticated.value = false;
    }
  }

  void checkFirstTime() async {}
  void guestReminder(context) async {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            alignment: Alignment.center,
            content: Text("Guest User , Please Login first !!"),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Continue as Guest")),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        backgroundColor: Color.fromARGB(224, 14, 187, 158)),
                    onPressed: () {
                      Get.offAllNamed(AppRoutes.authPage);
                    },
                    child: Text('Login'),
                  ),
                ],
              )
            ],
          );
        });
  }

  void logout() async {
    await localStorage.value.deleteFromStorage("Token");
    isAuthenticated.value = false;
    Get.offAllNamed(AppRoutes.authPage);
  }

  void loginAsGueast() {
    isGuestUser.value = true;
    guestUserImage.value =
        "https://secure.gravatar.com/avatar/3e942ed60cd7c63ba7fab0611917b259?s=96&d=retro&r=g";
  }

  Future<bool> refreshTokenIfNeeded() async {
    final refreshToken = await localStorage.value.readFromStorage('Token');

    if (refreshToken.isNotEmpty) {
      try {
        final newToken = await authService.value.refreshToken(refreshToken);
        print('new token');
        print(newToken);
        if (newToken.isNotEmpty) {
          await localStorage.value.writeToStorage('Token', newToken);

          return true;
        } else {
          logout();
          return false;
        }
      } catch (e) {
        
        return false;
      }
    } else {
      return false;
    }
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
          userNiceName: userData.userNicename.toString(),
          followers: userData.followers.toString(),
          followings: userData.followings.toString(),
          friends: userData.friends.toString());

      isAuthenticated.value = true;
      isGuestUser.value = false;
    } catch (e) {
      if (e is DioException) {
        var message = e.response!.data['message'].toString();

        statusMessage.value = message;
      }
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
        statusMessage.value =
            "User $email Registration was Successful. Verify your email!";
      } else {
        isRegistered.value = false;
      }
    } catch (e) {
      if (e is DioException) {
        var message = e.response!.data['message'].toString();

        statusMessage.value = message;
      }
      isAuthenticated.value = false;
      isRegistered.value = false;
    }
  }
}
