import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';
import 'package:mindplex/features/user_profile_displays/services/profileServices.dart';
import 'package:mindplex/utils/AppError.dart';
import 'package:mindplex/utils/Toster.dart';
import '../../../utils/status.dart';

// class BookmarksController extends BlogsController {
class BookmarksController extends GetxController {
  RxList<Blog> blogs = <Blog>[].obs;
  Rx<Status> status = Status.unknown.obs;
  RxString errorMessage = "Something is very wrong!".obs;
  ScrollController bookMarkScorllController = ScrollController();
  RxBool isReachedEndOfList = false.obs;
  RxInt blogPage = 1.obs;
  ProfileServices profileService = ProfileServices();
  @override
  void onInit() {
    super.onInit();
    bookMarkScorllController.addListener(() {
      if (!isReachedEndOfList.value &&
          bookMarkScorllController.position.pixels >=
              bookMarkScorllController.position.maxScrollExtent) {
        loadMoreBookmarks();
      }
    });
  }

  Future<List<Blog>> fetchApi() async {
    List<Blog> res =
        await profileService.getBookmarkPosts(page: blogPage.value);
    return res;
  }

  Future<void> loadMoreBookmarks() async {
    status(Status.loadingMore);
    blogPage.value += 1;

    List<Blog> res = await fetchApi();

    if (res.isEmpty) {
      isReachedEndOfList.value = true;
    } else {
      blogs.addAll(res);
    }

    status(Status.success);
  }

  // Future<List<Blog>> fetchApi();

  Future<void> loadBlogs() async {
    status(Status.loading);
    isReachedEndOfList.value = false;
    try {
      List<Blog> res = await fetchApi();

      if (res.isEmpty) {
        isReachedEndOfList.value = true;
      } else {
        blogs.value = res;
      }

      status(Status.success);
    } catch (e) {
      status(Status.error);
      if (e is AppError) {
        errorMessage(e.message);
      }
      Toster(message: errorMessage.value);
    }
  }
}
