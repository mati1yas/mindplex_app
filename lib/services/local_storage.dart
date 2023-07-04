import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  final FlutterSecureStorage flutterSecureStorage;

  LocalStorage({required this.flutterSecureStorage});

  Future<String> readFromStorage(String key) async {
    final String data = await flutterSecureStorage.read(key: key) ?? " ";

    return data;
  }

  Future<void> writeToStorage(String key, String value) async {
    await flutterSecureStorage.write(key: key, value: value);
    return;
  }
}
