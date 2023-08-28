import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
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
        'comment_content': content,
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
}
