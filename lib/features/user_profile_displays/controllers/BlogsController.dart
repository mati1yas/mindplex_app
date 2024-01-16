import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';
import 'package:mindplex/features/user_profile_displays/services/profileServices.dart';
import 'package:mindplex/utils/AppError.dart';
import 'package:mindplex/utils/Toster.dart';
import 'package:mindplex/utils/status.dart';

abstract class BlogsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      if (!isReachedEndOfList &&
          status != Status.loading &&
          status != Status.loadingMore &&
          scrollController.position.pixels >=
              scrollController.position.maxScrollExtent) {
        loadBlogs();
      }
    });
  }

  RxList<Blog> blogs = <Blog>[].obs;
  Rx<Status> status = Status.unknown.obs;
  RxString errorMessage = "Something is very wrong!".obs;
  ScrollController scrollController = ScrollController();
  bool isReachedEndOfList = false;
  RxInt blogPage = 1.obs;

  Future<List<Blog>> fetchApi();

  ProfileServices profileService = ProfileServices();
  Future<void> loadBlogs() async {
    if (blogPage.value == 1) {
      status(Status.loading);
    } else {
      status(Status.loadingMore);
    }

    try {
      List<Blog> res = await fetchApi();

      if (res.isEmpty) {
        isReachedEndOfList = true;
      } else {
        blogs.addAll(res);
      }

      status(Status.success);
      blogPage += 1;
    } catch (e) {
      status(Status.error);
      if (e is AppError) {
        errorMessage(e.message);
      }
      Toster(message: errorMessage.value);
    }
  }
}
