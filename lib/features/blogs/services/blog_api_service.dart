import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:mindplex/features/blogs/models/author_reputation_model.dart';

import '../../../utils/constatns.dart';
import '../../local_data_storage/local_storage.dart';

class BlogApiService {
  Future<bool> AddView(String blogSlug) async {
    try {
      var dio = Dio();
      Rx<LocalStorage> localStorage =
          LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;

      final token = await localStorage.value.readFromStorage('Token');

      dio.options.headers["Authorization"] = "Bearer ${token}";
      Response response = await dio.post("${AppUrls.blogAddViewUrl}$blogSlug");
      print(response.statusCode);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> postTimeSpent(String blogSlug) async {
    try {
      var dio = Dio();
      Rx<LocalStorage> localStorage =
          LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;

      final token = await localStorage.value.readFromStorage('Token');

      dio.options.headers["Authorization"] = "Bearer ${token}";
      Response response = await dio.post("${AppUrls.timeSpentUrl}/$blogSlug");
      print(response.statusCode);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<AuthorReputation>> loadReputation(
      {required List<int> userIds}) async {
    var dio = Dio();

    dio.options.headers["com-id"] = com_id;
    dio.options.headers["x-api-key"] = api_key;

    try {
      Response response = await dio.get(
          "${AppUrls.baseUrlReputation}/core/user_lists/?community=mindplex",
          data: <String, List<int>>{
            "ids": userIds,
          });

      var ret = <AuthorReputation>[];
      for (var authorReputation in response.data) {
        ret.add(AuthorReputation.fromJson(authorReputation));
      }
      return ret;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
