import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/authentication/models/auth_model.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';
import 'package:mindplex/features/user_profile_displays/services/profileServices.dart';
import 'package:mindplex/features/user_profile_settings/models/user_profile.dart';
import 'package:mindplex/services/api_services.dart';
import 'package:mindplex/features/local_data_storage/local_storage.dart';
import 'package:mindplex/utils/AppError.dart';
import 'package:mindplex/utils/Toster.dart';
import 'package:mindplex/utils/status.dart';

import '../../authentication/controllers/auth_controller.dart';
import '../../../utils/unkown_models/popularModel.dart';
import '../view/screens/about_screen.dart';
import '../view/screens/bookmark_screen.dart';
import '../view/screens/draft_screen.dart';

class ProfileController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchBlogs();

    scrollPostsController.addListener(() {
      if (!isReachedEndOfPostList &&
          status != Status.loading &&
          status != Status.loadingMore &&
          scrollPostsController.position.pixels >=
              scrollPostsController.position.maxScrollExtent) {
        loadPublishedPosts();
      }
    });
  }

  Rx<AuthModel> authenticatedUser = Rx<AuthModel>(AuthModel());
  RxString selectedTabCategory = "About".obs;
  RxBool isLoading = false.obs;
  RxString selectedBlogCategory = "Popular".obs;
  RxList<PopularDetails> blogs = <PopularDetails>[].obs;
  RxBool isWalletConnected = false.obs;

  Rx<UserProfile> userProfile = Rx<UserProfile>(UserProfile());

  final apiService = ApiService().obs;

  AuthController authController = Get.find();

  void switchWallectConnectedState() {
    isWalletConnected.value = true;
  }

  void switchTab({required String tab}) {
    selectedTabCategory.value = tab;
  }

  final localStorage =
      LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;

  Future<void> getAuthenticatedUser() async {
    if (authController.isGuestUser.isFalse) {
      authenticatedUser.value = await localStorage.value.readUserInfo();
    }
  }

  Future<void> getUserProfile({required String username}) async {
    isLoading.value = true;
    final res = await apiService.value.fetchUserProfile(userName: username);
    res.username = username;
    userProfile.value = res;
    postsPage.value = 1;
    publishedPosts.value = [];
    isReachedEndOfPostList = false;
    isLoading.value = false;
  }

  void fetchBlogs() async {
    final jsondata = await rootBundle.loadString('assets/demoAPI.json');

    final List<dynamic> populars = await jsonDecode(jsondata);

    List<PopularDetails> popularDetail = [];
    populars.forEach((jsonCategory) {
      PopularDetails popularCategory = PopularDetails.fromJson(jsonCategory);
      popularDetail.add(popularCategory);
    });

    blogs.value = popularDetail;
    isLoading.value = false;
  }

  void filterBlogsByCategory({required String category}) {
    selectedBlogCategory.value = category;
  }

  List<PopularDetails> get filteredBlogs {
    return blogs
        .where((blog) => blog.type == selectedBlogCategory.value)
        .toList();
  }

  RxList<Blog> publishedPosts = <Blog>[].obs;
  Rx<Status> status = Status.unknown.obs;
  RxString errorMessage = "Something is very wrong!".obs;
  ScrollController scrollPostsController = ScrollController();
  bool isReachedEndOfPostList = false;
  RxInt postsPage = 1.obs;

  ProfileServices profileService = ProfileServices();
  Future<void> loadPublishedPosts({int? page}) async {
    if (page != null) {
      publishedPosts([]);
      postsPage(page);
    }
    if (postsPage.value == 1) {
      status(Status.loading);
    } else {
      status(Status.loadingMore);
    }
    try {
      List<Blog> res = await profileService.getPublishedPosts(
          username: userProfile.value.username!, page: postsPage.value);
      if (res.isEmpty) {
        isReachedEndOfPostList = true;
      } else {
        publishedPosts.addAll(res);
      }
      status(Status.success);
      postsPage += 1;
    } catch (e) {
      status(Status.error);
      if (e is AppError) {
        errorMessage(e.message);
      }
      Toster(message: errorMessage.value);
    }
  }
}
