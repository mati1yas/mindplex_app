import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex_app/auth/auth_controller/auth_controller.dart';
import 'package:mindplex_app/profile/user_profile_controller.dart';
import 'package:page_transition/page_transition.dart';

import 'auth/auth.dart';
import 'main.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  AuthController authController = Get.put(AuthController());
  Future<void> loadUserInfo() async {
    if (authController.isAuthenticated.value) {
      ProfileController profileController = Get.put(ProfileController());
      await profileController.getAuthenticatedUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    authController.checkAuthentication();
    loadUserInfo();
    return Scaffold(
      body: AnimatedSplashScreen(
          splash: Image.asset('assets/images/logo.png'),
          duration: 3000,
          curve: Curves.easeInOut,
          splashIconSize: 350,
          splashTransition: SplashTransition.slideTransition,
          animationDuration: const Duration(milliseconds: 1500),
          backgroundColor: Colors.white,
          pageTransitionType: PageTransitionType.fade,
          nextScreen: Obx(() => !authController.isAuthenticated.value
              ? const AuthPage()
              : const MyHomePage(title: "Mindplex"))),
    );
  }
}
