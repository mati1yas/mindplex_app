import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' as getxprefix;

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:mindplex/features/comment/models/comment_model.dart';
import 'package:mindplex/features/local_data_storage/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/constatns.dart';
import '../../authentication/controllers/auth_controller.dart';

class CommentApiService {
  AuthController authenticationController = getxprefix.Get.find();
  Future<List<Comment>> fetchComments(
      {required String post_slug,
      int page = 1,
      int perPage = 10,
      String parent = '0'}) async {
    var dio = Dio();

    Rx<LocalStorage> localStorage =
        LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
    final token = await localStorage.value.readFromStorage('Token');

    print(
        '${AppUrls.commentsFetch}/$post_slug/$parent?page=$page&per_page=$perPage');
    if (authenticationController.isGuestUser.value == false)
      dio.options.headers["Authorization"] = "Bearer ${token}";
    Response response = await dio.get(
      '${AppUrls.commentsFetch}/$post_slug/$parent?page=$page&per_page=$perPage',
    );

    if (response.statusCode == 200) {
      final responseBody = response.data as List<dynamic>;
      final comments = responseBody.map((e) => Comment.fromJson(e)).toList();

      return comments;
    } else {
      throw Exception('Failed to fetch comments from the server.');
    }
  }

  Future<Comment> createComment(
      {required String post_slug,
      required String content,
      String parent = '0'}) async {
    var dio = Dio();

    Rx<LocalStorage> localStorage =
        LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;

    final token = await localStorage.value.readFromStorage('Token');
    dio.options.headers["Authorization"] = "Bearer ${token}";

    Response response = await dio.post(
      //'${AppUrls.commentCreate}/$post_slug/$parent',
      '${AppUrls.commentCreate}/$post_slug/$parent',
      queryParameters: {
        'comment_content': content,
      },
    );
    if (response.statusCode == 200) {
      final commentMap = response.data['comment'];
      final newComment = Comment.fromJson(commentMap);
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

    print("HERE IN COMMENT LIKE OR DISLIKE");
    print(commentId);
    Rx<LocalStorage> localStorage =
        LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;

    final token = await localStorage.value.readFromStorage('Token');
    dio.options.headers["Authorization"] = "Bearer ${token}";
    Response response = await dio.post(
      "${AppUrls.commentLikeDislike}/$commentId/?like_or_dislike=${like ? "L" : "D"}",
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to like/dislike the comment on the server.');
    }
  }

  Future<bool?> deleteComment({required String commentId}) async {
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
}
