import 'package:get/get.dart';
import 'package:mindplex_app/auth/auth.dart';
import 'package:mindplex_app/main.dart';
import 'package:mindplex_app/profile/personal_settings.dart';
import 'package:mindplex_app/profile/settings_page.dart';
import 'package:mindplex_app/splash_screen.dart';

import '../profile/Notifications_page.dart';
import '../profile/change_password.dart';
import '../profile/general_settings.dart';
import '../profile/preference.dart';
import '../profile/privacy_policy_page.dart';
import '../profile/profile_page.dart';
import '../profile/recommendation.dart';

final String email = Get.arguments['email'];

class AppRoutes {
  static const String home = '/';
  static const String authPage = '/auth';
  static const String landingPage = '/landingPage';

  static const String profilePage = '/profilePage';
  static const String verificationPage = '/verificationPage';
  static const String settingsPage = '/settingsPage';
  static const String generalSettingsPage = '/generalSettingsPage';
  static const String personalSettingsPage = '/personalSettingsPage';
  static const String changePasswordPage = '/changePasswordPage';
  static const String recommendationPage = '/recommendationPage';
  static const String preferencePage = '/preferencePage';
  static const String notificationsPage = '/notificationsPage';
  static const String privacyPolicyPage = '/privacyPolicyPage';

  static final List<GetPage> pages = [
    GetPage(name: home, page: () => SplashScreen()),
    GetPage(name: authPage, page: () => AuthPage()),
    GetPage(name: settingsPage, page: () => SettingsPage()),
    GetPage(name: generalSettingsPage, page: () => GeneralSettings()),
    GetPage(name: personalSettingsPage, page: () => PersonalSettingsPage()),
    GetPage(name: changePasswordPage, page: () => ChangePasswordPage()),
    GetPage(name: recommendationPage, page: () => RecommendationPage()),
    GetPage(name: preferencePage, page: () => PreferencePage()),
    GetPage(name: notificationsPage, page: () => NotificationPage()),
    GetPage(name: privacyPolicyPage, page: () => PrivacyPolicyPage()),
    GetPage(
        name: landingPage,
        page: () => MyHomePage(
          title: "Mindplex",
        )),
    GetPage(name: profilePage, page: () => const ProfilePage()),
  ];
}
