import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/search/services/search_api_service.dart';

import '../../blogs/models/blog_model.dart';
import '../../user_profile_settings/models/user_profile.dart';
import '../models/search_response.dart';

class SearchPageController extends GetxController{
  RxBool isLoadingMore = true.obs;
  RxInt searchPage = 1.obs;
  RxList<Blog> popularPosts = <Blog>[].obs;
  RxList<Blog> searchResults = <Blog>[].obs;
  RxString searchQuery = "".obs;

  ScrollController searchScrollController = ScrollController();
  RxBool reachedEndOfListSearch = false.obs;

  RxBool isIntialLoading = true.obs;
  RxBool showAllCategories = false.obs;
  RxList<Category> categories = <Category>[].obs;
  RxBool isLoading = true.obs;
  RxBool isSearchResultPage = false.obs;

  //profile search variables
  RxInt searchUserPage = 1.obs;
  ScrollController searchUserScrollController = ScrollController();
  RxBool reachedEndOfListSearchUser = false.obs;
  RxBool isUserLoading = true.obs;
  RxList<UserProfile> userSearchResults = <UserProfile>[].obs;
  RxBool isLoadingMoreUsers = true.obs;

  final apiService = SearchApiService().obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchPopularBlogs();
    searchScrollController.addListener(() {
      if (!reachedEndOfListSearch.value &&
          searchScrollController.position.pixels >=
              searchScrollController.position.maxScrollExtent) {
        // Load more data
        loadMoreSearchResults(searchQuery.value);
      }
    });

    searchUserScrollController.addListener(() {
      if (!reachedEndOfListSearchUser.value &&
          searchUserScrollController.position.pixels >=
              searchUserScrollController.position.maxScrollExtent) {
        // Load more data
        loadMoreUsers(searchQuery.value);
      }
    });
  }

  void fetchCategories() async {
    final res = await apiService.value.fetchSearchLanding();
    print(res.categories?[0].posts);
    categories.value = res.categories!;
    isIntialLoading.value = false;
  }

  void loadMoreSearchResults(String query) async {
    if (isLoadingMore.value || reachedEndOfListSearch.value) {
      return;
    }
    isLoadingMore.value = true;
    searchPage.value++; // Increment the page number

    final res = await apiService.value
        .fetchSearchResponse(query, searchPage.value.toInt());

    if (res.blogs!.isEmpty) {
      reachedEndOfListSearch.value = true;
      // Notify the user that there are no more posts for now
    } else {
      searchResults.addAll(res.blogs!);
    }

    isLoadingMore.value = false;

    update(); // Trigger UI update
  }

  void loadMoreUsers(String query) async{
    if (isLoadingMoreUsers.value || reachedEndOfListSearchUser.value) {
      return;
    }

    isLoadingMoreUsers.value = true;
    searchUserPage.value++; // Increment the page number

    final res = await apiService.value
        .fetchSearchResponse(query, searchPage.value.toInt());

    if (res.users!.isEmpty) {
      reachedEndOfListSearchUser.value = true;
    } else {
      userSearchResults.addAll(res.users!);
    }

    isLoadingMore.value = false;

    update();
  }

  void fetchPopularBlogs() async {
    final res = await apiService.value.fetchSearchLanding();

    popularPosts.value = res.blogs!;
    isLoadingMore.value = false;
  }

  void fetchSearchResults(String query) async {
    reachedEndOfListSearch.value = false;
    reachedEndOfListSearchUser.value = false;

    isLoadingMore.value = true;
    isLoadingMoreUsers.value = true;

    isLoading.value = true;
    isUserLoading.value = true;

    searchPage.value = 1;
    searchUserPage.value = 1;

    final res = await apiService.value.fetchSearchResponse(query, searchPage.value.toInt());

    if(res.blogs!.length < 10){
      reachedEndOfListSearch.value = true;
    }
    if (res.users!.length < 10) {
      reachedEndOfListSearchUser.value = true;
    }

    searchResults.value = res.blogs!;
    userSearchResults.value = res.users!;

    searchQuery.value = query;

    isLoadingMore.value = false;
    isLoadingMoreUsers.value = false;

    isLoading.value = false;
    isUserLoading.value = false;
  }

  List<Blog> get popularBlogs {
    return popularPosts;
  }

  List<Blog> get searchedBlogs {
    return searchResults;
  }

  List<UserProfile> get getSearchedUsers{
    return userSearchResults;
  }
}