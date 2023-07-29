import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/auth_model.dart';

class LocalStorage {
  final FlutterSecureStorage flutterSecureStorage;

  LocalStorage({required this.flutterSecureStorage});

  Future<String> readFromStorage(String key) async {
    final String data = await flutterSecureStorage.read(key: key) ?? "";

    return data;
  }

  Future<void> writeToStorage(String key, String value) async {
    await flutterSecureStorage.write(key: key, value: value);
    return;
  }

  Future<void> storeUserInfo({
    required String email,
    required String image,
    required String userDisplayName,
    required String username,
    required String firstName,
    required String lastName,
    required String userNiceName,
  }) async {
    writeToStorage("email", email);
    writeToStorage("image", image);
    writeToStorage("userDisplayName", userDisplayName);
    writeToStorage("username", username);
    writeToStorage("firstName", firstName);
    writeToStorage("lastName", lastName);
    writeToStorage("userNiceName", userNiceName);
  }

  Future<AuthModel> readUserInfo() async {
    String email = await readFromStorage(
      "email",
    );

    String token = await readFromStorage(
      "Token",
    );
    String image = await readFromStorage(
      "image",
    );
    String userDisplayName = await readFromStorage(
      "userDisplayName",
    );
    String userName = await readFromStorage(
      "username",
    );
    String firstName = await readFromStorage(
      "firstName",
    );
    String lastName = await readFromStorage(
      "lastName",
    );
    String userNiceName = await readFromStorage(
      "userNiceName",
    );
    var userData = {
      "user_email": email,
      'image': image,
      'token': token,
      'user_nicename': userNiceName,
      'user_display_name': userDisplayName,
      'username': userName,
      'first_name': firstName,
      'last_name': lastName,
    };

    print(userData);
    return AuthModel.fromJson(userData);
  }

  Future<void> deleteFromStorage(String key) async {
    await flutterSecureStorage.delete(
      key: key,
    );
    return;
  }
}
