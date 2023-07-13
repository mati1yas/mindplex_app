import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  Future<void> deleteFromStorage(String key) async {
    await flutterSecureStorage.delete(
      key: key,
    );
    return;
  }
}
