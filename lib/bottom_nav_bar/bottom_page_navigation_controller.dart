import 'package:get/get.dart';

class PageNavigationController extends GetxController {
  RxInt currentPage = 0.obs;

  void navigatePage(int pageIndex) {
    currentPage.value = pageIndex;
  }
}
