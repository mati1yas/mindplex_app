import 'package:dio/dio.dart';

import '../models/blog_model.dart';

class ApiSerivice {
  Future<List<Blog>> loadBlogs(
      {required String recommender,
      required String post_format,
      required int page}) async {
    var ret = <Blog>[];
    try {
      var dio = Dio();

      Response response = await dio.get(
          "https://staging.mindplex.ai/wp-json/mp_gl/v1/posts/$recommender/$post_format/$page");

      for (var blog in response.data['post']) {
        print(blog);
        ret.add(Blog.fromJson(blog));
      }
    } catch (e) {}
    print(ret.length);
    return ret;
  }
}
