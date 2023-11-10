import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:mindplex_app/models/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/blog_model.dart';
import '../models/comment.dart';
import '../utils/constatns.dart';
import 'local_storage.dart';

class ApiService {
  Future<List<Blog>> loadBlogs(
      {required String recommender,
      required String post_format,
      required int page}) async {
    var ret = <Blog>[];
    try {
      var dio = Dio();

      Rx<LocalStorage> localStorage =
          LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
      final token = await localStorage.value.readFromStorage('Token');

      dio.options.headers["Authorization"] = "Bearer ${token}";

      Response response =
          await dio.get("${AppUrls.blogUrl}/$recommender/$post_format/$page");

      for (var blog in response.data['post']) {
        print(blog);
        ret.add(Blog.fromJson(blog));
      }
    } catch (e) {}

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

  Future<List<Comment>> fetchComments(
      {required String post_slug,
      int page = 1,
      int perPage = 10,
      String parent = '0'}) async {
    var dio = Dio();

    Rx<LocalStorage> localStorage =
        LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
    final token = await localStorage.value.readFromStorage('Token');

    dio.options.headers["Authorization"] = "Bearer ${token}";
    Response response = await dio.get(
      '${AppUrls.commentsFetch}/$post_slug/$parent?page=$page&per_page=$perPage',
    );
    if (response.statusCode == 200) {
      final responseBody = response.data as List<dynamic>;
      final comments = responseBody.map((e) => Comment.fromMap(e)).toList();
      if (parent == '0') {
        for (Comment comment in comments) {
          print(comment.content);
          var replies = await fetchComments(
              post_slug: post_slug, parent: comment.id.toString());
          comment.replies = replies;
        }
      }
      return comments;
    } else {
      throw Exception('Failed to fetch comments from the server.');
    }
  }

  Future<Comment> createComment(
      {required String post_slug,
      required String content,
      String parent = '0'}) async {
    print('CREATING NEW COMMENT');
    // let's read the email, password, and login_with values from shared preferences.
    var dio = Dio();

    Rx<LocalStorage> localStorage =
        LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
    final token = await localStorage.value.readFromStorage('Token');
    dio.options.headers["Authorization"] = "Bearer ${token}";
/*
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
    */
    print('${AppUrls.commentCreate}/$post_slug/$parent');
    Response response = await dio.post(
      //'${AppUrls.commentCreate}/$post_slug/$parent',
      '${AppUrls.commentCreate}/$post_slug/$parent',
      queryParameters: {
        'comment_content': "&lt;p&gt;" + content + "&lt;p&gt;",
      },
    );
    if (response.statusCode == 200) {
      final commentMap = response.data['comment'] as Map<String, dynamic>;
      final newComment = Comment.fromMap(commentMap);
      return newComment;
    } else {
      throw Exception('Failed to create the comment on the server.');
    }
  }

  Future<bool?> updateComment(
      {required String commentId, required String newContent}) async {
    var dio = Dio();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
    Response response = await dio.patch(
      '${AppUrls.commentUpdate}/$commentId/?comment_content=$newContent',
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update the comment on the server.');
    }
  }

  Future<bool?> commentLikeDislike(String commentId, {bool like = true}) async {
    /// if the named parameter 'like' is set to false, it's considered as dislike.
    // this method returns true if the comment is liked/disliked successfully
    var dio = Dio();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
    Response response = await dio.post(
      "${AppUrls.commentLikeDislike}/$commentId/?like_or_dislike=${like ? 'L' : 'D'}",
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to like/dislike the comment on the server.');
    }
  }

  Future<bool?> deleteComment({required int commentId}) async {
    // this method returns true if the comment is deleted successfully
    var dio = Dio();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
    Response response = await dio.delete(
      '${AppUrls.commentDelete}/$commentId',
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete the comment from the server.');
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
      print(responseBody);
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

      Response response = await dio.post('${AppUrls.changeProfilePictureUrl}', data: formData);

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

  Future<String> changePassword(String password) async{
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
}
