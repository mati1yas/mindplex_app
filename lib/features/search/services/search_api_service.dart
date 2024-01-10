import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../utils/constatns.dart';
import '../../authentication/controllers/auth_controller.dart';
import '../../blogs/models/blog_model.dart';
import '../../local_data_storage/local_storage.dart';
import '../../user_profile_settings/models/user_profile.dart';
import '../models/search_response.dart';

class SearchApiService{

  AuthController authenticationController = Get.find();

  Future<SearchResponseLanding> fetchSearchLanding() async {
    var blogs = <Blog>[];
    var categories = <Category>[];
    SearchResponseLanding searchResponse = SearchResponseLanding();
    try {
      var dio = Dio();

      Rx<LocalStorage> localStorage =
          LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
      final token = await localStorage.value.readFromStorage('Token');
      if (authenticationController.isGuestUser.value == false)
        dio.options.headers["Authorization"] = "Bearer ${token}";

      Response response = await dio.get(AppUrls.searchLandingUrl);

      for (var blog in response.data['popular_posts']) {
        blogs.add(Blog.fromJson(blog));
      }
      for (var category in response.data['categories']) {
        categories.add(Category.fromJson(category));
      }
      searchResponse.categories = categories;
      searchResponse.blogs = blogs;
    } catch (e) {}

    return searchResponse;
  }

  Future<SearchResponse> fetchSearchResponse(String query, int page) async {
    var blogs = <Blog>[];
    var users = <UserProfile>[];

    SearchResponse searchResponse = SearchResponse();
    Map<String, dynamic> queryParameter = {'search_query': query, 'page': page};
    try {
      var dio = Dio();

      Rx<LocalStorage> localStorage =
          LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
      final token = await localStorage.value.readFromStorage('Token');
      if (authenticationController.isGuestUser.value == false)
        dio.options.headers["Authorization"] = "Bearer ${token}";

      Response response = await dio.get(AppUrls.searchLandingUrl,
          queryParameters: queryParameter);

      for (var blog in response.data['posts']) {
        blogs.add(Blog.fromJson(blog));
      }
      for (var user in response.data['users']) {
        users.add(UserProfile.fromJson(user));
      }
      searchResponse.users = users;
      searchResponse.blogs = blogs;
    } catch (e) {}

    return searchResponse;
  }
}