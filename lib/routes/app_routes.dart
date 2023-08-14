import 'package:get/get.dart';
import 'package:mindplex_app/auth/auth.dart';
import 'package:mindplex_app/main.dart';
import 'package:mindplex_app/splash_screen.dart';

import '../profile/profile_page.dart';

final String email = Get.arguments['email'];

class AppRoutes {
  static const String home = '/';
  static const String authPage = '/auth';
  static const String landingPage = '/landingPage';

  static const String profilePage = '/profilePage';
  static const String verificationPage = '/verificationPage';
  static final List<GetPage> pages = [
    GetPage(name: home, page: () => SplashScreen()),
    GetPage(name: authPage, page: () => AuthPage()),
    GetPage(
        name: landingPage,
        page: () => MyHomePage(
              title: "Mindplex",
            )),
    GetPage(name: profilePage, page: () => const ProfilePage()),
  ];
}
