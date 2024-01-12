import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/authentication/models/auth_model.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';
import 'package:mindplex/features/user_profile_displays/controllers/BlogsType.dart';
import 'package:mindplex/features/user_profile_displays/services/profileServices.dart';
import 'package:mindplex/features/user_profile_settings/models/user_profile.dart';
import 'package:mindplex/services/api_services.dart';
import 'package:mindplex/features/local_data_storage/local_storage.dart';
import 'package:mindplex/utils/AppError.dart';
import 'package:mindplex/utils/Toster.dart';
import 'package:mindplex/utils/status.dart';

import '../../authentication/controllers/auth_controller.dart';

class UserProfileController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      if (!isReachedEndOfList &&
          status != Status.loading &&
          status != Status.loadingMore &&
          scrollController.position.pixels >=
              scrollController.position.maxScrollExtent) {
        loadBlog();
      }
    });
  }

  Rx<AuthModel> authenticatedUser = Rx<AuthModel>(AuthModel());
  RxString selectedTabCategory = "About".obs;
  RxBool isLoading = false.obs;

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
      print(authenticatedUser.value);
    }
  }

  Future<void> getUserProfile({required String username}) async {
    isLoading.value = true;
    final res = await apiService.value.fetchUserProfile(userName: username);
    res.username = username;
    userProfile.value = res;
    page.value = 1;
    blogs.value = [];
    isReachedEndOfList = false;
    isLoading.value = false;
  }

  RxList<Blog> blogs = <Blog>[].obs;
  Rx<Status> status = Status.unknown.obs;
  RxString errorMessage = "Something is very wrong!".obs;
  ScrollController scrollController = ScrollController();
  bool isReachedEndOfList = false;
  RxInt page = 1.obs;
  Rx<BlogsType> blogType = BlogsType.unKnown.obs;

  void switchBlogType({required BlogsType type}) {
    blogType.value = type;
    page.value = 1;
    blogs.value = [];
    isReachedEndOfList = false;
    loadBlog();
  }

  ProfileServices profileService = ProfileServices();
  Future<void> loadBlog({int? pageNum}) async {
    if (page != null) {
      blogs([]);
      page(pageNum ?? 1);
    }
    if (page.value == 1) {
      status(Status.loading);
    } else {
      status(Status.loadingMore);
    }
    try {
      List<Blog> res = await profileService.getBlogs(
          username: userProfile.value.username!,
          page: page.value,
          blogType: blogType.value);

      if (res.isEmpty) {
        isReachedEndOfList = true;
      } else {
        blogs.addAll(res);
      }
      status(Status.success);
      page += 1;
    } catch (e) {
      status(Status.error);
      if (e is AppError) {
        errorMessage(e.message);
      }
      Toster(message: errorMessage.value);
    }
  }
}
