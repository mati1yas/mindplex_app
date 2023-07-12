import 'package:get/get.dart';
import 'package:mindplex_app/splash_screen.dart';
import 'package:mindplex_app/ui/screens/home.dart';

class AppRoutes {
  static const String home = '/';
  static const String landingPage = '/landingPage';

  static final List<GetPage> pages = [
    GetPage(name: home, page: () => SplashScreen()),
    GetPage(name: landingPage, page: () => Home())
  ];
}
