import 'package:get/get.dart';
import 'package:mindplex/features/authentication/controllers/auth_controller.dart';
import 'package:mindplex/features/blogs/controllers/blogs_controller.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';
import 'package:mindplex/features/bottom_navigation_bar/controllers/bottom_page_navigation_controller.dart';
import 'package:mindplex/features/drawer/model/drawer_model.dart';
import 'package:mindplex/features/drawer/model/drawer_types.dart';
import 'package:mindplex/features/user_profile_displays/controllers/DraftedPostsController.dart';
import 'package:mindplex/routes/app_routes.dart';
import 'package:mindplex/utils/colors.dart';

class DrawerButtonController extends GetxController {
  BlogsController _blogsController = Get.find();
  DraftedPostsController draftedPostsController = Get.find();

  PageNavigationController _pageNavigationController = Get.find();

  AuthController _authController = Get.find();

  // Have a list that handles pages that hasn't been implemented yet
  // This is for Alpha and Beta Tests so that the app won't crash
  final Set<String> availablePages = {
    '/landingPage',
    '/profilePage',
    '/aboutMindPlex',
    '/moderatorsPage',
    '/verificationPage',
    '/auth',
    '/settingsPage',
    '/personalSettingsPage',
    '/changePasswordPage',
    '/recommendationPage',
    '/preferencePage',
    '/notificationsPage',
    '/privacyPolicyPage',
    '/searchResultPage',
    '/generalSettingsPage',
    '/faq',
    '/constitutionPage',
    '/contributePage',
    '/privacyPage',
    '/termsPage'
  };
  final currentDrawerType = DrawerType.read.obs;

  changeDrawerType(DrawerType drawerType) {
    currentDrawerType.value = drawerType;
  }

  navigateToPage(DrawerModel drawerModel) {
    if (!availablePages.contains(drawerModel.pageName)) {
      Get.back();
      Get.snackbar(
        '🚧Page Under Construction🚧',
        'TODO: IMPLEMENT ${drawerModel.pageName}',
        backgroundColor: white,
      );
      return;
    } else if (drawerModel.pageName == AppRoutes.landingPage) {
      if (_authController.checkUserPrivellege(
        requiresPrivilege: drawerModel.requiresPrivilege,
      )) {
        Get.back();
        _loadContents(drawerModel.postType!, drawerModel.postFormat!);

        _pageNavigationController.navigatePage(0);
      }
    } else if (_authController.checkUserPrivellege(
      requiresPrivilege: drawerModel.requiresPrivilege,
    )) {
      Get.back();
      Get.toNamed(drawerModel.pageName, parameters: drawerModel.parameters);
    }
    currentDrawerType.value = drawerModel.drawerType;
  }

  _loadContents(String postType, String postFormat) {
    draftedPostsController.resetDrafting();
    _blogsController.loadContents(postType, postFormat);
  }
}
