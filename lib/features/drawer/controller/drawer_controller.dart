import 'package:get/get.dart';
import 'package:mindplex/features/blogs/controllers/blogs_controller.dart';
import 'package:mindplex/features/bottom_navigation_bar/controllers/bottom_page_navigation_controller.dart';
import 'package:mindplex/features/drawer/model/drawer_model.dart';
import 'package:mindplex/features/drawer/model/drawer_types.dart';

class DrawerButtonController extends GetxController {
  BlogsController _blogsController = Get.find();
  PageNavigationController _pageNavigationController = Get.find();

  final currentDrawerType = DrawerType.read.obs;

  changeDrawerType(DrawerType drawerType) {
    currentDrawerType.value = drawerType;
  }

  navigateToPage(DrawerModel drawerModel) {
    currentDrawerType.value = drawerModel.drawerType;
    Get.back();

    if (drawerModel.pageName == '/landingPage') {
      _loadContents(drawerModel.postType!, drawerModel.postFormat!);
      _pageNavigationController.navigatePage(0);
    } else {
      Get.toNamed(drawerModel.pageName);
    }
  }

  _loadContents(String postType, String postFormat) {
    _blogsController.loadContents(postType, postFormat);
  }
}
