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
    var url = "${AppUrls.draftBaseUrl + "${page}"}";
    return getBlogs(url, BlogsType.drafted_posts);
  }

  Future<Blog> createNewDraft(
      {required String postContent, required List<String> images}) async {
    try {
      Dio dio = Dio();

      Rx<LocalStorage> localStorage =
          LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
      final token = await localStorage.value.readFromStorage('Token');
      dio.options.headers["Authorization"] = "Bearer ${token}";

      Map<String, dynamic> requestData = {};
      if (postContent != "") requestData["post_content"] = postContent;
      if (images.isNotEmpty) requestData["images"] = images;

      Response response =
          await dio.post(AppUrls.draftBaseUrl, data: requestData);

      return Blog.fromJson(response.data["drafted_post"]);
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

  Future<void> updateDraft(
      {required String draftId,
      required String postContent,
      required List<String> images}) async {
    try {
      Dio dio = Dio();

      Rx<LocalStorage> localStorage =
          LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
      final token = await localStorage.value.readFromStorage('Token');

      dio.options.headers["Authorization"] = "Bearer ${token}";

      Map<String, dynamic> requestData = {};
      if (postContent != "") requestData["post_content"] = postContent;
      if (images.isNotEmpty) requestData["images"] = images;
      requestData["draft_id"] = draftId;

      Response response =
          await dio.post(AppUrls.draftBaseUrl, data: requestData);
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

  Future<void> postDraftToSocial(
      {required String draftId,
      required String postContent,
      required List<String> images}) async {
    try {
      Dio dio = Dio();

      Rx<LocalStorage> localStorage =
          LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
      final token = await localStorage.value.readFromStorage('Token');

      dio.options.headers["Authorization"] = "Bearer ${token}";

      Map<String, dynamic> requestData = {};
      if (postContent != "") requestData["post_content"] = postContent;
      if (images.isNotEmpty) requestData["images"] = images;
      requestData["draft_id"] = draftId;

      Response response =
          await dio.post('${AppUrls.postUrl}', data: requestData);
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

  Future<void> postNewToSocial(
      {required String postContent, required List<String> images}) async {
    print("About To Post new To Social Service Level");
    try {
      Dio dio = Dio();

      Rx<LocalStorage> localStorage =
          LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
      final token = await localStorage.value.readFromStorage('Token');

      Map<String, dynamic> requestData = {};
      if (postContent != "") requestData["post_content"] = postContent;
      if (images.isNotEmpty) requestData["images"] = images;

      dio.options.headers["Authorization"] = "Bearer ${token}";
      Response response = await dio.post(AppUrls.postUrl, data: requestData);
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

  Future<void> deleteDraft({required String draftId}) async {
    try {
      Dio dio = Dio();

      Rx<LocalStorage> localStorage =
          LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
      final token = await localStorage.value.readFromStorage('Token');
      dio.options.headers["Authorization"] = "Bearer ${token}";
      Response response = await dio.delete(
          '${AppUrls.draftBaseUrl + '${int.parse(draftId)}'}',
          data: <String, dynamic>{"draft_id": draftId});
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
