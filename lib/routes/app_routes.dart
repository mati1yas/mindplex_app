import 'package:get/get.dart';
import 'package:mindplex_app/splash_screen.dart';
import 'package:mindplex_app/ui/screens/home.dart';

import '../profile/profile_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String landingPage = '/landingPage';
  static const String profilePage = '/profilePage';

  static final List<GetPage> pages = [
    GetPage(name: home, page: () => SplashScreen()),
    GetPage(name: landingPage, page: () => const Home()),
    GetPage(name: profilePage, page: () => const ProfilePage())
  ];
}
