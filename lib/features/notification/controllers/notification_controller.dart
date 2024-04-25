import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mindplex/services/api_services.dart';
import 'package:mindplex/features/local_data_storage/local_storage.dart';
import 'package:mindplex/utils/Toster.dart';
import 'package:mindplex/utils/awesome_snackbar.dart';
import 'package:mindplex/utils/network/connection-info.dart';
import 'package:mindplex/utils/snackbar_constants.dart';

import '../models/notification_model.dart';

class NotificationController extends GetxController {
  RxInt unseenNotification = 0.obs;

  RxBool firstTimeLoading = true.obs;
  RxList<NotificationModel> notificationList = <NotificationModel>[].obs;

  RxBool isLoadingNotifications = false.obs;
  final apiService = ApiService().obs;
  RxInt page = 0.obs;
  RxBool reachedEndofNotifications = false.obs;
  ScrollController notificationPageScrollController = ScrollController();
  ConnectionInfoImpl connectionChecker = Get.find();
  RxBool isConnected = true.obs;
  @override
  void onInit() {
    super.onInit();
    notificationPageScrollController.addListener(() async {
      if (!reachedEndofNotifications.value &&
          notificationPageScrollController.position.pixels >=
              notificationPageScrollController.position.maxScrollExtent) {
        page.value++;

        isLoadingNotifications.value = true;
        Map<String, dynamic> notificationMap =
            await apiService.value.loadNotification(pageNumber: page.value);
        if (notificationMap['notificationList'].length == 0) {
          reachedEndofNotifications.value = true;
        } else {
          if (notificationMap['notificationList'].length < 10)
            reachedEndofNotifications.value = true;
          notificationList.addAll(notificationMap['notificationList']);
        }
      }

      isLoadingNotifications.value = false;
    });
  }

  Future<BuildContext> getContext() async {
    BuildContext? context = Get.context;
    return context!;
  }

  Future<void> loadNotifications() async {
    try {
      isConnected.value = true;
      if (!await connectionChecker.isConnected) {
        throw NetworkException(
            "Looks like there is problem with your connection.");
      }
      isLoadingNotifications.value = true;
      page.value += 1;

      Map<String, dynamic> notificationMap =
          await apiService.value.loadNotification(pageNumber: page.value);

      notificationList.addAll(notificationMap['notificationList']);
      if (notificationMap['notificationList'].length < 10)
        reachedEndofNotifications.value = true;
      isLoadingNotifications.value = false;
      firstTimeLoading.value = false;
    } catch (e) {
      if (e is NetworkException) {
        isConnected.value = false;
        showSnackBar(
            context: await getContext(),
            title: SnackBarConstantTitle.failureTitle,
            message: SnackBarConstantMessage.noInternetConnection,
            type: "failure");
      } else {
        print(e.toString());
        showSnackBar(
            context: await getContext(),
            title: SnackBarConstantTitle.failureTitle,
            message: SnackBarConstantMessage.unKnowenError,
            type: "failure");
      }
    }
    isLoadingNotifications.value = false;
    firstTimeLoading.value = false;
  }
}
