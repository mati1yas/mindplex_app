import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' as getxprefix;
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';
import 'package:mindplex/features/local_data_storage/local_storage.dart';
import 'package:mindplex/utils/AppError.dart';
import 'package:mindplex/utils/constatns.dart';
import "../../authentication/controllers/auth_controller.dart";

class ProfileServices {
  AuthController authenticationController = getxprefix.Get.find();
  Future<List<Blog>> getPublishedPosts({required String username}) async {
    Dio dio = Dio();

    try {
      Rx<LocalStorage> localStorage =
          LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
      final token = await localStorage.value.readFromStorage('Token');
      if (authenticationController.isGuestUser.value == false)
        dio.options.headers["Authorization"] = "Bearer ${token}";

      Response response =
          await dio.get("${AppUrls.profileUrl}/${username}?type=full");

      if (response.statusCode == 200) {
        List<Blog> publishedPosts = [];
        for (var post in response.data["published_posts"]) {
          publishedPosts.add(Blog.fromJson(post));
        }
        return publishedPosts;
      } else {
        throw new AppError(
            message: response.data.message, statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw new AppError(
            message: e.response?.statusMessage ?? "Something is very wrong!",
            statusCode: e.response?.statusCode);
      } else {
        throw new AppError(message: e.message ?? "Something is very wrong!");
      }
    } catch (e) {
      print("unkownError:\n${e}");
      throw new AppError(message: "Something is very wrong!");
    }
  }
}
