import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:mindplex/features/authentication/models/auth_model.dart';
import 'package:mindplex/utils/constatns.dart';

class AuthService {
  Future<AuthModel> loginUser(
      {required String email,
      required String password,
      required String loginType}) async {
    try {
      var dio = Dio();
      Response response = await dio.post(
        AppUrls.loginUrl,
        data: jsonEncode(<String, dynamic>{
          'username': email,
          'password': password,
          'login_with': loginType,
        }),
      );

      return AuthModel.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<String> refreshToken(String refreshToken) async {
    try {
      var dio = Dio();
      final response = await dio.post(
        AppUrls.refreshTokenUrl,
        data: {'token': refreshToken},
      );

      if (response.statusCode == 200) {
        final newToken = response.data['token'];
        return newToken;
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  Future<String> register(
      {required String email,
      required String firstName,
      required String lastName,
      required String password}) async {
    try {
      var dio = Dio();

      Response response = await dio.post(AppUrls.registerationUrl,
          data: jsonEncode(<String, String>{
            "registed_with": "email_password",
            "email": email,
            "first_name": firstName,
            "last_name": lastName,
            "password": password
          }));

      return response.statusCode.toString();
    } catch (e) {
      throw e;
    }
  }
}
