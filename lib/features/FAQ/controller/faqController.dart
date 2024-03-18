import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:mindplex/features/FAQ/model/FaqAnswer.dart';
import 'package:mindplex/features/FAQ/model/FaqList.dart';
import 'package:mindplex/features/FAQ/model/faqGroup.dart';
import 'package:mindplex/features/FAQ/model/faqGroups.dart';
import 'package:mindplex/features/FAQ/model/faqModel.dart';
import 'package:mindplex/features/FAQ/services/FaqSerivces.dart';
import 'package:mindplex/utils/AppError.dart';
import 'package:mindplex/utils/Toster.dart';
import 'package:mindplex/utils/status.dart';

class FaqController extends GetxController {
  RxString currentFaq = ("").obs;
  RxString viewMore = ("").obs;

  RxList<FaqGroup> faqGroups = <FaqGroup>[].obs;
  Rx<Status> status = Status.unknown.obs;
  Rx<Status> statusAnswer = Status.unknown.obs;
  RxList<FaqAnswer> faqAnswers = <FaqAnswer>[].obs;
  RxString errorMessage = "Something is very wrong!".obs;
  FaqService faqService = FaqService();

  void loadFaq() async {
    try {
      status(Status.loading);
      List<FaqGroup> res = await faqService.getFaq();
      faqGroups.addAll(res);
      status(Status.success);
    } catch (e) {
      status(Status.error);
      if (e is AppError) {
        errorMessage(e.message);
      }
      Toster(message: errorMessage.value);
    }
  }

  void loadAnswer(String slug) async {
    try {
      statusAnswer(Status.loading);
      faqAnswers([]);
      List<FaqAnswer> res = await faqService.getFaqBySlug(slug);
      faqAnswers.addAll(res);
      statusAnswer(Status.success);
    } catch (e) {
      statusAnswer(Status.error);
      if (e is AppError) {
        errorMessage(e.message);
      }
      Toster(message: errorMessage.value);
    }
  }

  void toggleView(String slug) {
    if (viewMore.value == slug) {
      viewMore.value = "";
      return;
    }
    viewMore(slug);
  }
}
