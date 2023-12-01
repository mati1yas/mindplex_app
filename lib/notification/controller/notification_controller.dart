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
  Future<void> loadNotifications() async {
    isLoadingNotifications.value = true;
    LocalStorage localStorage =
        LocalStorage(flutterSecureStorage: FlutterSecureStorage());

    String token = await localStorage.readFromStorage("Token");
    Map<String, dynamic> notificationMap =
        await apiService.value.loadNotification(token);
    print(notificationMap);

    notificationList.value = notificationMap['notificationList'];
    isLoadingNotifications.value = false;
  }
}
