import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../utils/constatns.dart';
import '../../local_data_storage/local_storage.dart';
import '../models/user_profile.dart';

class SettingsApiService{
  Future<UserProfile> fetchUserProfile({required String userName}) async {
    var dio = Dio();

    Rx<LocalStorage> localStorage =
        LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
    final token = await localStorage.value.readFromStorage('Token');

    dio.options.headers["Authorization"] = "Bearer ${token}";
    Response response = await dio.get(
      '${AppUrls.profileUrl}/$userName',
    );
    if (response.statusCode == 200) {
      final responseBody = response.data;
      print(responseBody);
      UserProfile userProfile = UserProfile.fromJson(responseBody);
      return userProfile;
    } else {
      throw Exception('Failed to fetch user profile from the server.');
    }
  }

  Future<String> updateUserProfile(
      {required UserProfile updatedProfile}) async {
    var dio = Dio();
    Rx<LocalStorage> localStorage =
        LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
    final token = await localStorage.value.readFromStorage('Token');
    dio.options.headers["Authorization"] = "Bearer $token";
    Response response = await dio.patch(
      '${AppUrls.editProfileUrl}',
      data: updatedProfile.toJson(),
    );
    if (response.statusCode == 200) {
      final responseBody = response.data;
      return responseBody.toString();
    } else {
      throw Exception('Failed to update user profile.');
    }
  }

  Future<String?> changeProfilePicture(String base64Image) async {
    try {
      Dio dio = Dio();
      Rx<LocalStorage> localStorage =
          LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
      final token = await localStorage.value.readFromStorage('Token');
      dio.options.headers["Authorization"] = "Bearer $token";

      FormData formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(
          base64Decode(base64Image),
          filename: 'profileImage.jpg',
        ),
      });

      Response response =
      await dio.post('${AppUrls.changeProfilePictureUrl}', data: formData);

      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        print('Failed to send image. Error: ${response.statusMessage}');
        return "Failed to send Image";
      }
    } catch (error) {
      print('Error sending image: $error');
    }
  }

  Future<String> changePassword(String password) async {
    var dio = Dio();
    Rx<LocalStorage> localStorage =
        LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
    final token = await localStorage.value.readFromStorage('Token');
    dio.options.headers["Authorization"] = "Bearer $token";
    Map<String, dynamic> passwordData = {
      'password': password,
    };
    String jsonData = jsonEncode(passwordData);
    Response response = await dio.patch(
      '${AppUrls.changePasswordUrl}', //user name is needed here??
      data: jsonData,
    );
    if (response.statusCode == 200) {
      final responseBody = response.data;
      return responseBody.toString();
      // UserProfile userProfile = UserProfile.fromJson(responseBody);
      // return userProfile;
    } else {
      throw Exception('Failed to change password.');
    }
  }
}