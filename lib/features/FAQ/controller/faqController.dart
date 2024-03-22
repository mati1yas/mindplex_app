import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/FAQ/model/FaqAnswer.dart';
import 'package:mindplex/features/FAQ/model/faqGroup.dart';
import 'package:mindplex/features/FAQ/model/faqQuestion.dart';
import 'package:mindplex/features/FAQ/services/FaqSerivces.dart';
import 'package:mindplex/utils/AppError.dart';
import 'package:mindplex/utils/Toster.dart';
import 'package:mindplex/utils/status.dart';

class FaqController extends GetxController {
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      if (!isReachedEndOfList &&
          searchStatus != Status.loading &&
          searchStatus != Status.loadingMore &&
          scrollController.position.pixels >=
              scrollController.position.maxScrollExtent) {
        searchFaq();
      }
    });
  }

  RxString currentFaq = ("").obs;
  RxString viewMore = ("").obs;

  RxList<FaqGroup> faqGroups = <FaqGroup>[].obs;
  Rx<Status> status = Status.unknown.obs;
  Rx<Status> statusAnswer = Status.unknown.obs;
  RxList<FaqAnswer> faqAnswers = <FaqAnswer>[].obs;
  RxString errorMessage = "Something is very wrong!".obs;
  FaqService faqService = FaqService();

  RxList<FaqQuestion> faqSearchResult = <FaqQuestion>[].obs;
  Rx<Status> searchStatus = Status.unknown.obs;
  RxString searchQuery = "".obs;
  ScrollController scrollController = ScrollController();
  bool isReachedEndOfList = false;
  RxInt searchPage = 1.obs;
  RxBool searchMode = false.obs;

  void searchFaq([String? search]) async {
    if (search != null) {
      searchQuery(search);
      searchPage(1);
      faqSearchResult([]);
      isReachedEndOfList = false;
    }
    ;

    if (searchPage.value == 1) {
      searchStatus(Status.loading);
    } else {
      searchStatus(Status.loadingMore);
    }

    //Pp searchStatus(Status.loading);

    try {
      List<FaqQuestion> res =
          await faqService.getFaqBySearch(searchQuery.value, searchPage.value);
      if (res.isEmpty) {
        isReachedEndOfList = true;
      } else {
        faqSearchResult.addAll(res);

        print([search, faqSearchResult, searchStatus, searchPage]);
      }

      searchStatus(Status.success);
      print(searchStatus);

      searchPage += 1;
    } catch (e) {
      searchStatus(Status.error);

      if (e is AppError) {
        errorMessage(e.message);
      }
      Toster(message: errorMessage.value);
    }

    // update();
  }

  void loadFaq() async {
    try {
      status(Status.loading);
      faqGroups([]);
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

  changeSearchMode(bool mode) {
    if (mode == false) {
      searchQuery("");
      searchStatus(Status.unknown);
      searchPage(1);
      faqSearchResult([]);
      faqGroups([]);
      isReachedEndOfList = false;
    }
    searchMode(mode);
  }
}
