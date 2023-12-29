import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mindplex/services/api_services.dart';
import 'package:mindplex/features/local_data_storage/local_storage.dart';

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

  Future<void> loadNotifications() async {
    isLoadingNotifications.value = true;
    page.value += 1;

    Map<String, dynamic> notificationMap =
        await apiService.value.loadNotification(pageNumber: page.value);

    notificationList.addAll(notificationMap['notificationList']);
    if (notificationMap['notificationList'].length < 10)
      reachedEndofNotifications.value = true;
    isLoadingNotifications.value = false;
    firstTimeLoading.value = false;
  }
}
