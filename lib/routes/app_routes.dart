import 'package:get/get.dart';
import 'package:mindplex/features/authentication/view/screens/auth.dart';
import 'package:mindplex/main.dart';
import 'package:mindplex/features/user_profile_settings/view/screens/settings_page.dart';
import 'package:mindplex/features/search/view/screens/search_result_page.dart';
import 'package:mindplex/splash_screen.dart';

import '../features/notification/view/screens/notification_page.dart';
import '../features/user_profile_displays/view/screens/profile_page.dart';
import '../features/user_profile_settings/view/screens/change_password.dart';
import '../features/user_profile_settings/view/screens/general_settings.dart';
import '../features/user_profile_settings/view/screens/personal_settings.dart';
import '../features/user_profile_settings/view/screens/preference.dart';
import '../features/user_profile_settings/view/screens/recommendation.dart';

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
  static const String searchResultPage = '/searchResultPage';

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
    GetPage(
        name: landingPage,
        page: () => MyHomePage(
              title: "Mindplex",
            )),
    GetPage(name: profilePage, page: () => const ProfilePage()),
    GetPage(name: searchResultPage, page: () => SearchResultPage())
  ];
}

class PrivacyPolicyPage {}
