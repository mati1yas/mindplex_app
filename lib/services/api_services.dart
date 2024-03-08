import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' as getxprefix;
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:mindplex/features/blogs/controllers/blogs_controller.dart';
import 'package:mindplex/features/blogs/models/reputation_model.dart';
import 'package:mindplex/features/blogs/models/social_feed_setting_model.dart';
import 'package:mindplex/features/search/models/search_response.dart';
import 'package:mindplex/features/notification/models/notification_model.dart';
import 'package:mindplex/features/user_profile_settings/models/user_profile.dart';

import '../features/authentication/controllers/auth_controller.dart';
import '../features/blogs/models/blog_model.dart';
import '../features/comment/models/comment_model.dart';
import '../utils/constatns.dart';
import '../features/local_data_storage/local_storage.dart';

class ApiService {
  AuthController authenticationController = getxprefix.Get.find();

  Future<List<Blog>> loadBlogs(
      {required String recommender,
      required String post_format,
      required String post_type,
      required int page}) async {
    var ret = <Blog>[];

    BlogsController blogsController = getxprefix.Get.find();

    try {
      var dio = Dio();

      Rx<LocalStorage> localStorage =
          LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
      final token = await localStorage.value.readFromStorage('Token');
      ;

      //  condition to check if the  user is guest user or not to extract token
      if (authenticationController.isGuestUser.value == false)
        dio.options.headers["Authorization"] = "Bearer ${token}";

      Response response = await dio
          .get("${AppUrls.blogUrl}/$post_type/$recommender/$post_format/$page");

      //  THIS checks if there is categories feild on the response
      if (response.data['categories'] != null) {
        blogsController.topicPostCategories.value =
            RxList(response.data['categories']);
      }

      if (response.data['settings'] != null) {
        blogsController.socialFeedSetting.value =
            SocialFeedSetting.fromJson(response.data['settings']);
      }
      for (var blog in response.data['post']) {
        if (blog["post_type_format"].runtimeType == List) continue;
        ret.add(Blog.fromJson(blog));
      }
    } catch (e) {
      throw e.toString();
    }

    return ret;
  }

  Future<List<Reputation>> loadReputation({required List<String> slugs}) async {
    var dio = Dio();

    dio.options.headers["com-id"] = com_id;
    dio.options.headers["x-api-key"] = api_key;

    Response response = await dio.get(
        "${AppUrls.baseUrlReputation}/core/post_user_detail/?community=mindplex",
        data: <String, List<String>>{
          "slug": slugs,
        });

    var ret = <Reputation>[];
    for (var reputation in response.data) {
      ret.add(Reputation.fromJson(reputation));
    }
    return ret;
  }

  Future<void> likeDislikeArticle(
      {required String articleSlug, required String interction}) async {
    var dio = Dio();
    Rx<LocalStorage> localStorage =
        LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
    final token = await localStorage.value.readFromStorage('Token');

    dio.options.headers["Authorization"] = "Bearer ${token}";

    Response response = await dio
        .post("${AppUrls.likeDislike}$articleSlug?like_or_dislike=$interction");

    print('like$response');
  }

  Future<void> reactWithEmoji(
      {required String articleSlug, required String emoji_value}) async {
    var dio = Dio();
    Rx<LocalStorage> localStorage =
        LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
    final token = await localStorage.value.readFromStorage('Token');

    dio.options.headers["Authorization"] = "Bearer ${token}";

    Response response = await dio.post("${AppUrls.reactWithEmoji}$articleSlug",
        data: <String, String>{
          "reaction_type": "post",
          "emoji_value": emoji_value
        });

    print(response.data);
  }

  Future<void> addToBookmark({
    required String articleSlug,
    required bool hasBookmarked,
  }) async {
    var dio = Dio();
    Rx<LocalStorage> localStorage =
        LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
    final token = await localStorage.value.readFromStorage('Token');
    dio.options.headers['Authorization'] = "Bearer ${token}";

    Response response = await dio.post(
      "${AppUrls.bookmark}$articleSlug?",
      data: <String, String>{
        "code": "bookmark_posts",
        "message": hasBookmarked ? 'added' : 'removed',
      },
    );
  }

  Future<void> addVote(
      {required int articleSlug, required bool hasVoted}) async {
    try {
      var dio = Dio();
      Rx<LocalStorage> localStorage =
          LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
      final token = await localStorage.value.readFromStorage('Token');
      dio.options.headers['Authorization'] = "Bearer ${token}";
      Response response = await dio.get(
        "${AppUrls.vote}$articleSlug",
      );
      if (response.statusCode == 200) {
        print('hi there ${response.data}');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('error from the voting feature $e');
    }
  }

  Future<void> removePreviousInteraction(
      {required String articleSlug, required String interction}) async {
    var dio = Dio();
    Rx<LocalStorage> localStorage =
        LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
    final token = await localStorage.value.readFromStorage('Token');

    dio.options.headers["Authorization"] = "Bearer ${token}";

    Response response = await dio.post(
        "${AppUrls.likeDislike}$articleSlug?is_remove=1&like_or_dislike=$interction");
  }

  Future<bool> followUser(String username) async {
    try {
      var dio = Dio();
      Rx<LocalStorage> localStorage =
          LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;

      final token = await localStorage.value.readFromStorage('Token');

      dio.options.headers["Authorization"] = "Bearer ${token}";
      Response response = await dio.post("${AppUrls.followUrl}/$username");
      print(response.statusCode);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> unfollowUser(String username) async {
    try {
      var dio = Dio();
      Rx<LocalStorage> localStorage =
          LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;

      final token = await localStorage.value.readFromStorage('Token');

      dio.options.headers["Authorization"] = "Bearer ${token}";
      Response response = await dio.post("${AppUrls.unfollowUrl}/$username");
      print(response.statusCode);
      return true;
    } catch (e) {
      if (e is DioException) {
        return true;
      }
      return false;
    }
  }

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

  Future<Map<String, dynamic>> loadNotification(
      {required int pageNumber}) async {
    var dio = Dio();
    Rx<LocalStorage> localStorage =
        LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
    final token = await localStorage.value.readFromStorage('Token');
    if (authenticationController.isGuestUser.value == false)
      dio.options.headers["Authorization"] = "Bearer ${token}";

    try {
      Response response = await dio.get(
          AppUrls.baseUrl + "/mp_rp/v1/user/notifications?page=$pageNumber");

      Map<String, dynamic> notificationsMap = {};

      List<NotificationModel> notifications = [];

      //  builds map of string with real notification model list and integers which is count of unseen notification
      for (var notif in response.data['notifs']) {
        notifications.add(NotificationModel.fromJson(notif));
      }
      notificationsMap['notificationList'] = notifications;
      notificationsMap['unseen'] = response.data['not_seen'];
      return notificationsMap;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<dynamic>> fetchUserInteractions(
      {required String articleSlug}) async {
    var dio = Dio();

    Rx<LocalStorage> localStorage =
        LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
    final token = await localStorage.value.readFromStorage('Token');

    if (!authenticationController.isGuestUser.value) {
      dio.options.headers["Authorization"] = "Bearer $token";
    }
    print(articleSlug);

    Response response =
        await dio.get("${AppUrls.reactWithEmoji}$articleSlug/all/1");

    if (response.statusCode == 200) {
      final interactions = response.data['interaction'];
      return interactions;
    } else {
      throw Exception('Failed to fetch user interactions from the server.');
    }
  }

  Future<List<dynamic>> fetchUserInteraction(
      {required String articleSlug, required String interactionType}) async {
    var dio = Dio();

    Rx<LocalStorage> localStorage =
        LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
    final token = await localStorage.value.readFromStorage('Token');

    if (!authenticationController.isGuestUser.value) {
      dio.options.headers["Authorization"] = "Bearer $token";
    }

    Response response = await dio
        .get("${AppUrls.reactWithEmoji}$articleSlug/$interactionType/1");

    if (response.statusCode == 200) {
      final interactions = response.data['interaction'];
      return interactions;
    } else {
      throw Exception('Failed to fetch user interactions from the server.');
    }
  }

  Future<List<dynamic>> fetchUserFollowers(
      {required String username, required int page}) async {
    var dio = Dio();

    Rx<LocalStorage> localStorage =
        LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
    final token = await localStorage.value.readFromStorage('Token');

    if (!authenticationController.isGuestUser.value) {
      dio.options.headers["Authorization"] = "Bearer $token";
    }
    print("${AppUrls.followers}$username/$page");
    Response response = await dio.get("${AppUrls.followers}$username/$page");

    if (response.statusCode == 200) {
      final followers = response.data['data'];
      print(followers);
      return followers;
    } else {
      throw Exception('Failed to fetch user followers from the server.');
    }
  }

  Future<List<dynamic>> fetchUserFollowings(
      {required String username, required int page}) async {
    var dio = Dio();

    Rx<LocalStorage> localStorage =
        LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
    final token = await localStorage.value.readFromStorage('Token');

    if (!authenticationController.isGuestUser.value) {
      dio.options.headers["Authorization"] = "Bearer $token";
    }
    print("${AppUrls.followings}$username/$page");
    Response response = await dio.get("${AppUrls.followings}$username/$page");

    if (response.statusCode == 200) {
      final followings = response.data['data'];
      print(followings);
      return followings;
    } else {
      throw Exception('Failed to fetch user followings from the server.');
    }
  }
}
