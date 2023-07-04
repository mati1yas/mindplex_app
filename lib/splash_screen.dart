
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:mindplex_app/main.dart';
import 'package:page_transition/page_transition.dart';

import 'auth/auth.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

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
          nextScreen: signedIn ? const AuthPage() : const MyHomePage(title: "Mindplex"),
      ),
    );
  }
}
