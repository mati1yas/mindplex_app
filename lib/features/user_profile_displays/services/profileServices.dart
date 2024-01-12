import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' as getxprefix;
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';
import 'package:mindplex/features/local_data_storage/local_storage.dart';
import 'package:mindplex/features/user_profile_displays/controllers/BlogsType.dart';
import 'package:mindplex/utils/AppError.dart';
import 'package:mindplex/utils/constatns.dart';
import "../../authentication/controllers/auth_controller.dart";

var urlMap = {
  BlogsType.published_posts: "/mp_gl/v1/posts/publisher/",
  BlogsType.bookmarked_posts: "/mp_gl/v1/posts/bookmarks",
};

class ProfileServices {
  AuthController authenticationController = getxprefix.Get.find();

  Future<List<Blog>> getBlogs(
      {required String username,
      required int page,
      required BlogsType blogType}) async {
    Dio dio = Dio();

    try {
      Rx<LocalStorage> localStorage =
          LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
      final token = await localStorage.value.readFromStorage('Token');
      if (authenticationController.isGuestUser.value == false)
        dio.options.headers["Authorization"] = "Bearer ${token}";
      var url =
          "${AppUrls.baseUrl}${urlMap[blogType]}${blogType == BlogsType.published_posts ? username : ""}/${page}";
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List<Blog> blogs = [];
        for (var post in response.data[blogType]) {
          blogs.add(Blog.fromJson(post));
        }
        return blogs;
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
