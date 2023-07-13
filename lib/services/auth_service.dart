import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mindplex_app/models/auth_model.dart';
import 'package:mindplex_app/utils/constatns.dart';

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
}
