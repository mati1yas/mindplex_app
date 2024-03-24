import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/FAQ/model/FaqAnswer.dart';
import 'package:mindplex/features/FAQ/model/faqGroup.dart';
import 'package:mindplex/features/FAQ/model/faqQuestion.dart';
import 'package:mindplex/features/authentication/controllers/auth_controller.dart';
import 'package:mindplex/features/local_data_storage/local_storage.dart';
import 'package:mindplex/utils/AppError.dart';
import 'package:mindplex/utils/constatns.dart';

class FaqService {
  AuthController authenticationController = Get.find();
  Future<List<T>> loadData<T>(
      String url, String key, Function factoryContructor) async {
    Dio dio = Dio();
    try {
      Rx<LocalStorage> localStorage =
          LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
      final token = await localStorage.value.readFromStorage('Token');
      if (authenticationController.isGuestUser.value == false)
        dio.options.headers["Authorization"] = "Bearer ${token}";
      var response = await dio.get(url);
      if (response.statusCode == 200) {
        List<T> dataList = [];
        for (var data in response.data[key]) {
          dataList.add(factoryContructor(data));
        }
        return dataList;
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

  Future<List<FaqGroup>> getFaq() async {
    return await loadData<FaqGroup>(
        '${AppUrls.baseUrl}/mp_gl/v1/faqs/list', "faq_list", (data) {
      return FaqGroup.fromJson(data);
    });
  }

  Future<List<FaqAnswer>> getFaqBySlug(String slug) async {
    return await loadData<FaqAnswer>(
        '${AppUrls.baseUrl}/mp_gl/v1/faqs/question/${slug}', "faq_answer",
        (data) {
      return FaqAnswer.fromJson(data);
    });
  }

  Future<List<FaqQuestion>> getFaqBySearch(String query, int page) async {
    return await loadData<FaqQuestion>(
        '${AppUrls.baseUrl}/mp_gl/v1/faqs/search/${page}?query=${query}',
        "faqs", (data) {
      return FaqQuestion.fromJson(data);
    });
  }
}
