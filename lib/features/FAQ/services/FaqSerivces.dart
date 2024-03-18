import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/FAQ/model/FaqAnswer.dart';
import 'package:mindplex/features/FAQ/model/faqGroup.dart';
import 'package:mindplex/features/authentication/controllers/auth_controller.dart';
import 'package:mindplex/features/local_data_storage/local_storage.dart';
import 'package:mindplex/utils/AppError.dart';
import 'package:mindplex/utils/constatns.dart';

class FaqService {
  AuthController authenticationController = Get.find();
  Future<List<FaqGroup>> getFaq() async {
    Dio dio = Dio();
    try {
      Rx<LocalStorage> localStorage =
          LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
      final token = await localStorage.value.readFromStorage('Token');
      if (authenticationController.isGuestUser.value == false)
        dio.options.headers["Authorization"] = "Bearer ${token}";
      var response = await dio.get('${AppUrls.baseUrl}/mp_gl/v1/faqs/list');
      if (response.statusCode == 200) {
        List<FaqGroup> faqGroups = [];
        for (var faqGroup in response.data["faq_list"]) {
          faqGroups.add(FaqGroup.fromJson(faqGroup));
        }
        return faqGroups;
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

  Future<List<FaqAnswer>> getFaqBySlug(String slug) async {
    Dio dio = Dio();
    try {
      Rx<LocalStorage> localStorage =
          LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
      final token = await localStorage.value.readFromStorage('Token');
      if (authenticationController.isGuestUser.value == false)
        dio.options.headers["Authorization"] = "Bearer ${token}";
      print("slug: ${slug}");
      var response =
          await dio.get('${AppUrls.baseUrl}/mp_gl/v1/faqs/question/${slug}');
      if (response.statusCode == 200) {
        List<FaqAnswer> faqAnswers = [];
        print(response.data);
        for (var faqAnswer in response.data["faq_answer"]) {
          faqAnswers.add(FaqAnswer.fromJson(faqAnswer));
        }
        print(faqAnswers);
        return faqAnswers;
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
}
