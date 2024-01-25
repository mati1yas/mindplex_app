import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';
import 'package:mindplex/features/user_profile_displays/controllers/BlogsController.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';
import 'package:mindplex/features/user_profile_displays/services/profileServices.dart';
import 'package:mindplex/utils/AppError.dart';
import 'package:mindplex/utils/Toster.dart';
import 'package:mindplex/utils/status.dart';

class PublishPostController extends GetxController {
  RxList<Blog> blogs = <Blog>[].obs;
  Rx<Status> status = Status.unknown.obs;
  RxString errorMessage = "Something is very wrong!".obs;
  ScrollController publishedScorllController = ScrollController();
  RxBool isReachedEndOfList = false.obs;
  RxInt blogPage = 1.obs;
  ProfileServices profileService = ProfileServices();
  ProfileController profileController = Get.find();
  @override
  void onInit() {
    super.onInit();
    publishedScorllController.addListener(() {
      if (!isReachedEndOfList.value &&
          publishedScorllController.position.pixels >=
              publishedScorllController.position.maxScrollExtent) {
        loadMorePublished();
      }
    });
  }

  Future<List<Blog>> fetchApi() async {
    List<Blog> res = await profileService.getPublisedPosts(
      username: profileController.userProfile.value.username!,
      page: blogPage.value,
    );
    return res;
  }

  Future<void> loadMorePublished() async {
    status(Status.loadingMore);
    blogPage.value += 1;

    List<Blog> res = await fetchApi();

    if (res.isEmpty) {
      isReachedEndOfList.value = true;
    } else {
      blogs.addAll(res);
    }

    print(blogs.length);
    status(Status.success);
  }

  // Future<List<Blog>> fetchApi();

  Future<void> loadBlogs() async {
    status(Status.loading);
    isReachedEndOfList.value = false;
    blogPage.value = 1;

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
