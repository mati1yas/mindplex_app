import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/blogs/models/reputation_model.dart';
import 'package:mindplex/features/search/services/search_api_service.dart';
import 'package:mindplex/services/api_services.dart';
import 'package:mindplex/utils/Toster.dart';
import 'package:mindplex/utils/network/connection-info.dart';

import '../../blogs/models/blog_model.dart';
import '../../user_profile_settings/models/user_profile.dart';
import '../models/search_response.dart';

class SearchPageController extends GetxController {
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
  RxBool loadingReputation = false.obs;

  final searchApiService = SearchApiService().obs;
  final apiService = ApiService().obs;
  RxInt startPosition = 0.obs;
  ConnectionInfoImpl connectionChecker = Get.find();
  RxBool isConnected = false.obs;

  RxBool searchFailed = false.obs;

  @override
  void onInit() {
    super.onInit();

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

  void fetchPopularBlogs() async {
    searchFailed.value = false;
    try {
      isConnected.value = true;
      if (!await connectionChecker.isConnected) {
        throw NetworkException(
            "Looks like there is problem with your connection.");
      }
      final res = await searchApiService.value.fetchSearchLanding();

      popularPosts.value = res.blogs!;
      loadReputation(popularPosts, 'popular');
      categories.value = res.categories!;
      isIntialLoading.value = false;

      isLoadingMore.value = false;
    } catch (e) {
      if (e is NetworkException) {
        isConnected.value = false;
        Toster(
            message: 'No Internet Connection', color: Colors.red, duration: 1);
      } else {
        print(e.toString());
        searchFailed.value = true;
        Toster(
            message: 'Something is Wrong,Try Again !',
            color: Colors.red,
            duration: 1);
      }
    }
  }

  void loadMoreSearchResults(String query) async {
    if (isLoadingMore.value || reachedEndOfListSearch.value) {
      return;
    }
    isLoadingMore.value = true;
    searchPage.value++; // Increment the page number

    final res = await searchApiService.value
        .fetchSearchResponse(query, searchPage.value.toInt());

    if (res.blogs!.isEmpty) {
      reachedEndOfListSearch.value = true;
      // Notify the user that there are no more posts for now
    } else {
      startPosition.value = searchResults.length;
      searchResults.addAll(res.blogs!);
      loadReputation(res.blogs ?? [], 'search');
    }

    isLoadingMore.value = false;

    update(); // Trigger UI update
  }

  void loadMoreUsers(String query) async {
    if (isLoadingMoreUsers.value || reachedEndOfListSearchUser.value) {
      return;
    }

    isLoadingMoreUsers.value = true;
    searchUserPage.value++; // Increment the page number

    final res = await searchApiService.value
        .fetchSearchResponse(query, searchUserPage.value.toInt());

    if (res.users!.isEmpty) {
      reachedEndOfListSearchUser.value = true;
    } else {
      userSearchResults.addAll(res.users!);
    }

    isLoadingMore.value = false;

    update();
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
    startPosition.value = 0;

    final res = await searchApiService.value
        .fetchSearchResponse(query, searchPage.value.toInt());

    if (res.blogs!.length < 10) {
      reachedEndOfListSearch.value = true;
      if (res.blogs!.length > 1) {
        searchPage++;
      }
    }
    if (res.users!.length < 10) {
      reachedEndOfListSearchUser.value = true;
      if (res.users!.length > 1) {
        searchUserPage++;
      }
    }

    searchResults.value = res.blogs!;
    loadReputation(res.blogs ?? [], 'search');
    userSearchResults.value = res.users!;

    searchQuery.value = query;

    isLoadingMore.value = false;
    isLoadingMoreUsers.value = false;

    isLoading.value = false;
    isUserLoading.value = false;
  }

  Future<void> followUnfollowUser(
      int index, String userName, bool isFollowing) async {
    getSearchedUsers[index].isSendingFollowRequest!.value = true;

    try {
      if (!await connectionChecker.isConnected) {
        throw NetworkException(
            "Looks like there is problem with your connection.");
      }
      if (isFollowing) {
        await unfollowUser(index, userName);
      } else {
        await followUser(index, userName);
      }
    } catch (e) {
      if (e is NetworkException) {
        isConnected.value = false;
        Toster(
            message: 'No Internet Connection', color: Colors.red, duration: 1);
      } else {
        Toster(message: 'Failed To Follow', color: Colors.red, duration: 1);
      }
    }
    getSearchedUsers[index].isSendingFollowRequest!.value = false;
  }

  Future<void> followUser(int index, String userName) async {
    if (await apiService.value.followUser(userName)) {
      getSearchedUsers[index].isFollowing!.value = true;
    }
  }

  Future<void> unfollowUser(int index, String userName) async {
    if (await apiService.value.unfollowUser(userName)) {
      getSearchedUsers[index].isFollowing!.value = false;
    }
  }

  Future<void> loadReputation(List<Blog> fetchedBlogs, String blogType) async {
    loadingReputation.value = true;

    try {
      List<String> slugs =
          await fetchedBlogs.map((blog) => blog.slug!).toList();
      slugs.length;

      List<Reputation> reputations =
          await apiService.value.loadReputation(slugs: slugs);

      assignReputationToBlog(
          fetchedBlogs: fetchedBlogs,
          reputations: reputations,
          blogType: blogType);
    } catch (e) {
      if (e is DioException) {
        Toster(message: 'Failed To Load Mpxr', color: Colors.red, duration: 3);
      }
    }

    loadingReputation.value = false;
  }

  void assignReputationToBlog(
      {required List<Blog> fetchedBlogs,
      required List<Reputation> reputations,
      required String blogType}) {
    for (var i = 0; i < fetchedBlogs.length; i++) {
      for (var j = 0; j < reputations.length; j++) {
        if (fetchedBlogs[i].slug == reputations[j].postSlug) {
          fetchedBlogs[i].reputation.value = reputations[j];

          if (blogType == 'popular') {
            popularPosts[startPosition.value + i] = fetchedBlogs[i];
          } else if (blogType == 'search') {
            searchResults[startPosition.value + i] = fetchedBlogs[i];
          }

          update();
          break;
        }
      }
    }
  }

  List<Blog> get popularBlogs {
    return popularPosts;
  }

  List<Blog> get searchedBlogs {
    return searchResults;
  }

  List<UserProfile> get getSearchedUsers {
    return userSearchResults;
  }
}
