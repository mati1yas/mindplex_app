import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex_app/auth/auth_controller/auth_controller.dart';
import 'package:mindplex_app/main.dart';
import 'package:mindplex_app/profile/profile_page.dart';
import 'package:page_transition/page_transition.dart';

import 'auth/auth.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    // ToDo: check if user signedIn or not
    bool signedIn = true;

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
        nextScreen:
            // ignore: dead_code
            !signedIn ? const AuthPage() : const MyHomePage(title: "Mindplex"),
      ),
    );
  }
}
