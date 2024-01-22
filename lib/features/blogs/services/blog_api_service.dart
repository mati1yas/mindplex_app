import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../utils/constatns.dart';
import '../../local_data_storage/local_storage.dart';

class BlogApiService{
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

}