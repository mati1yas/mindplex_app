import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mindplex_app/services/api_services.dart';
import 'package:mindplex_app/services/local_storage.dart';

import '../../models/notification_model.dart';

class NotificationController extends GetxController {
  RxInt unseenNotification = 0.obs;
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
        Map<String, dynamic> notificationMap =
            await apiService.value.loadNotification(pageNumber: page.value);
        if (notificationMap['notificationList'].isEmpty) {
          reachedEndofNotifications.value = true;
        } else {
          notificationList.addAll(notificationMap['notificationList']);
        }
      }
    });
  }

  Future<void> loadNotifications() async {
    isLoadingNotifications.value = true;

    Map<String, dynamic> notificationMap =
        await apiService.value.loadNotification(pageNumber: page.value);
    print(notificationMap);

    notificationList.value = notificationMap['notificationList'];
    isLoadingNotifications.value = false;
  }
}
