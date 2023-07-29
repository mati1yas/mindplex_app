import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mindplex_app/models/auth_model.dart';
import 'package:mindplex_app/services/local_storage.dart';

class ProfileController extends GetxController {
  Rx<AuthModel> authenticatedUser = Rx<AuthModel>(AuthModel());

  final localStorage =
      LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
  Future<void> getAuthenticatedUser() async {
    authenticatedUser.value = await localStorage.value.readUserInfo();
  }
}
