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

var blogsTypes = {
  BlogsType.published_posts: "published_posts",
  BlogsType.bookmarked_posts: "bookmarked_posts",
  BlogsType.drafted_posts: "drafted_posts",
};

class ProfileServices {
  AuthController authenticationController = getxprefix.Get.find();

  Future<List<Blog>> getBlogs(String url, blogType) async {
    Dio dio = Dio();
    try {
      Rx<LocalStorage> localStorage =
          LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
      final token = await localStorage.value.readFromStorage('Token');
      if (authenticationController.isGuestUser.value == false)
        dio.options.headers["Authorization"] = "Bearer ${token}";
      Response response = await dio.get(url);
      print(response);
      if (response.statusCode == 200) {
        List<Blog> blogs = [];
        for (var post in response.data[blogsTypes[blogType]]) {
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

  Future<List<Blog>> getBookmarkPosts({required int page}) {
    var url = "${AppUrls.baseUrl}/mp_gl/v1/posts/bookmarks/${page}";
    return getBlogs(url, BlogsType.bookmarked_posts);
  }

  Future<List<Blog>> getPublisedPosts(
      {required String username, required int page}) {
    var url = "${AppUrls.baseUrl}/mp_gl/v1/posts/publisher/${username}/${page}";
    return getBlogs(url, BlogsType.published_posts);
  }

  Future<List<Blog>> getDraftPosts({required int page}) {
    var url = "${AppUrls.baseUrl}/mp_up/v1/post/draft/${page}";
    return getBlogs(url, BlogsType.drafted_posts);
  }
}
