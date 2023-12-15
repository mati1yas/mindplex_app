import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mindplex/models/auth_model.dart';
import 'package:mindplex/models/user_profile.dart';
import 'package:mindplex/profile/user_profile_displays/draft_screen.dart';
import 'package:mindplex/services/api_services.dart';
import 'package:mindplex/services/local_storage.dart';

import '../auth/auth_controller/auth_controller.dart';
import '../models/popularModel.dart';
import 'user_profile_displays/about_screen.dart';
import 'user_profile_displays/bookmark_screen.dart';

class ProfileController extends GetxController {
  Rx<AuthModel> authenticatedUser = Rx<AuthModel>(AuthModel());
  RxString selectedTabCategory = "About".obs;
  RxBool isLoading = false.obs;
  RxString selectedBlogCategory = "Popular".obs;
  RxList<PopularDetails> blogs = <PopularDetails>[].obs;
  RxBool isWalletConnected = false.obs;

  Rx<UserProfile> userProfile = Rx<UserProfile>(UserProfile());

  final apiService = ApiService().obs;

  AuthController authController = Get.find();

  var screens = [
    {'name': 'About', 'active': true, 'widget': const AboutScreen(), "num": 1},
    {
      'name': 'Published Content',
      "active": false,
      'widget': const BookmarkScreen(),
      "num": 2
    },
    {
      'name': 'Bookmarks',
      "active": false,
      'widget': const BookmarkScreen(),
      "num": 2
    },
    {'name': 'Drafts', "active": false, 'widget': const DraftScreen(), "num": 3}
  ];

  ScrollController searchScrollController = ScrollController();
  bool reachedEndOfListSearch = false;
  RxList<UserProfile> searchResults = <UserProfile>[].obs;
  RxString searchQuery = "".obs;
  RxInt searchPage = 1.obs;
  
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
    userProfile.value = res;
    isLoading.value = false;
  }

  void fetchSearchResults(String query) async{
    reachedEndOfListSearch = false;
    isLoading.value = true;
    searchPage.value = 1;
    final res = await apiService.value.fetchSearchResponse(query,searchPage.value.toInt());
    if(res.users!.isEmpty){
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

    final res = await apiService.value.fetchSearchResponse(query,searchPage.value.toInt());

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

  List<PopularDetails> get filteredBlogs {
    return blogs
        .where((blog) => blog.type == selectedBlogCategory.value)
        .toList();
  }

  List<UserProfile> get searchedUsers {
    return searchResults;
  }
}
