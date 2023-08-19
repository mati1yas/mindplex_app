import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/blog_model.dart';
import '../models/comment.dart';
import '../utils/constatns.dart';

class ApiSerivice {
  Future<List<Blog>> loadBlogs(
      {required String recommender,
      required String post_format,
      required int page}) async {
    var ret = <Blog>[];
    try {
      var dio = Dio();

      Response response =
          await dio.get("${AppUrls.blogUrl}/$recommender/$post_format/$page");

      for (var blog in response.data['post']) {
        print(blog);
        ret.add(Blog.fromJson(blog));
      }
    } catch (e) {}
    print(ret.length);
    return ret;
  }

  Future<List<Comment>> fetchComments(
      {required String lessonId,
      int page = 1,
      int perPage = 10,
      String parent = '0'}) async {
    var dio = Dio();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
    Response response = await dio.get(
      '${AppUrls.commentsFetch}/$lessonId/$parent?&per_page=$perPage',
      queryParameters: {'page': '$page', 'per_page': '$perPage'},
    );
    if (response.statusCode == 200) {
      final responseBody = response.data as List<dynamic>;
      final comments = responseBody.map((e) => Comment.fromMap(e)).toList();
      if (parent == '0') {
        for (Comment comment in comments) {
          var replies = await fetchComments(
              lessonId: lessonId, parent: comment.id.toString());
          comment.replies = replies;
        }
      }
      return comments;
    } else {
      throw Exception('Failed to fetch comments from the server.');
    }
  }

  Future<Comment> createComment(
      {required String lessonId,
      required String content,
      String parent = '0'}) async {
    // let's read the email, password, and login_with values from shared preferences.
    var dio = Dio();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
    Response response = await dio.post(
      '${AppUrls.commentCreate}/$lessonId/$parent',
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
