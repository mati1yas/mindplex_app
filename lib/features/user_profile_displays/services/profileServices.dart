import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' as getxprefix;
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';
import 'package:mindplex/features/local_data_storage/local_storage.dart';
import 'package:mindplex/utils/constatns.dart';
import "../../authentication/controllers/auth_controller.dart";

class ProfileServices {
  AuthController authenticationController = getxprefix.Get.find();

  // Get published posts
  Future<List<Blog>> getPublishedPosts({required String username}) async {
    var dio = Dio();
    Rx<LocalStorage> localStorage =
        LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
    final token = await localStorage.value.readFromStorage('Token');

    if (authenticationController.isGuestUser.value == false)
      dio.options.headers["Authorization"] = "Bearer ${token}";
    Response response =
        await dio.get("${AppUrls.profileUrl}/${username}?type=full");

    List<Blog> publishedPosts = [];
    for (var post in response.data["published_posts"]) {
      publishedPosts.add(Blog.fromJson(post));
    }

    return publishedPosts;
  }
}
