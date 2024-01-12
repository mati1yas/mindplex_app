import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../../utils/unkown_models/popularModel.dart';
import '../view/screens/about_screen.dart';
import '../view/screens/bookmark_screen.dart';
import '../view/screens/draft_screen.dart';

class ProfileController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchBlogs();
    searchScrollController.addListener(() {
      if (!reachedEndOfListSearch &&
          searchScrollController.position.pixels >=
              searchScrollController.position.maxScrollExtent) {
        // Load more data
        loadMoreSearchResults(searchQuery.value);
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

  ScrollController searchScrollController = ScrollController();
  bool reachedEndOfListSearch = false;
  RxList<UserProfile> searchResults = <UserProfile>[].obs;
  RxString searchQuery = "".obs;
  RxInt searchPage = 1.obs;

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

  void fetchSearchResults(String query) async {
    reachedEndOfListSearch = false;
    isLoading.value = true;
    searchPage.value = 1;
    final res = await apiService.value
        .fetchSearchResponse(query, searchPage.value.toInt());
    if (res.users!.isEmpty) {
      reachedEndOfListSearch = true;
    }
    searchResults.value = res.users!;
    searchQuery.value = query;
    isLoading.value = false;
  }

  void loadMoreSearchResults(String query) async {
    if (isLoading.value || reachedEndOfListSearch) {
      return;
    }

    isLoading.value = true;
    searchPage.value++; // Increment the page number

    final res = await apiService.value
        .fetchSearchResponse(query, searchPage.value.toInt());

    if (res.users!.isEmpty) {
      reachedEndOfListSearch = true;
      // Notify the user that there are no more posts for now
    } else {
      searchResults.addAll(res.users!);
    }

    isLoading.value = false;

    update(); // Trigger UI update
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

  List<PopularDetails> get filteredBlogblogss {
    return blogs
        .where((blog) => blog.type == selectedBlogCategory.value)
        .toList();
  }

  List<UserProfile> get searchedUsers {
    return searchResults;
  }


   Future<void> getUserProfile({required String username}) async {
    isLoading.value = true;
    final res = await apiService.value.fetchUserProfile(userName: username);
    res.username = username;
    userProfile.value = res;
    page.value = 1;
    profileBlogs.value = [];
    isReachedEndOfList = false;
    isLoading.value = false;
  }

  RxList<Blog> profileBlogs = <Blog>[].obs;
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
        profileBlogs.addAll(res);
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
