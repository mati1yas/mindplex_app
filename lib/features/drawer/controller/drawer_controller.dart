import 'package:get/get.dart';
import 'package:mindplex/features/blogs/controllers/blogs_controller.dart';
import 'package:mindplex/features/bottom_navigation_bar/controllers/bottom_page_navigation_controller.dart';
import 'package:mindplex/features/drawer/model/drawer_model.dart';
import 'package:mindplex/features/drawer/model/drawer_types.dart';
import 'package:mindplex/utils/colors.dart';

class DrawerButtonController extends GetxController {
  BlogsController _blogsController = Get.find();
  PageNavigationController _pageNavigationController = Get.find();

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
  };
  final currentDrawerType = DrawerType.read.obs;

  changeDrawerType(DrawerType drawerType) {
    currentDrawerType.value = drawerType;
  }

  navigateToPage(DrawerModel drawerModel) {
    Get.back();

    if (!availablePages.contains(drawerModel.pageName)) {
      Get.snackbar(
        '🚧Page Under Construction🚧',
        'TODO: IMPLEMENT ${drawerModel.pageName}',
        backgroundColor: white,
      );
      return;
    } else if (drawerModel.pageName == '/landingPage') {
      _loadContents(drawerModel.postType!, drawerModel.postFormat!);
      _pageNavigationController.navigatePage(0);
    } else {
      Get.toNamed(drawerModel.pageName);
    }
    currentDrawerType.value = drawerModel.drawerType;
  }

  _loadContents(String postType, String postFormat) {
    _blogsController.loadContents(postType, postFormat);
  }
}
