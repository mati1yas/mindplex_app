import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/authentication/models/auth_model.dart';
import 'package:mindplex/features/user_profile_displays/cache_service/profile_cache_service.dart';
import 'package:mindplex/features/user_profile_displays/models/user_profile_reputation_model.dart';
import 'package:mindplex/features/user_profile_displays/services/profileServices.dart';

import 'package:mindplex/features/user_profile_settings/models/user_profile.dart';
import 'package:mindplex/services/api_services.dart';
import 'package:mindplex/features/local_data_storage/local_storage.dart';
import 'package:mindplex/utils/Toster.dart';

import '../../../utils/network/connection-info.dart';
import '../../authentication/controllers/auth_controller.dart';
import '../../../utils/unkown_models/popularModel.dart';

class ProfileController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // fetchBlogs();
  }

  Rx<AuthModel> authenticatedUser = Rx<AuthModel>(AuthModel());
  RxString selectedTabCategory = "About".obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingReputation = false.obs;
  RxString selectedBlogCategory = "Popular".obs;
  RxList<PopularDetails> blogs = <PopularDetails>[].obs;
  RxBool isWalletConnected = false.obs;
  RxList followers = [].obs;
  RxList followings = [].obs;
  RxBool isLoadingFollowers = false.obs;
  RxBool isLoadingFollowings = false.obs;
  RxBool firstTimeLoading = true.obs;
  RxBool firstTimeLoadingFollowings = true.obs;
  RxBool isConnected = true.obs;

  RxInt page = 0.obs;
  RxInt followingsPage = 0.obs;
  RxBool reachedEndofFollowers = false.obs;
  RxBool reachedEndofFollowings = false.obs;
  RxBool isSendingFollowRequest = false.obs;
  RxBool isSendingFriendRequest = false.obs;

  Rx<UserProfile> userProfile = Rx<UserProfile>(UserProfile());

  final apiService = ApiService().obs;

  final userProfileApiService = ProfileServices().obs;
  final userProfileCacheService = ProfileCacheService().obs;

  AuthController authController = Get.find();

  ConnectionInfoImpl connectionChecker = Get.find();

  void resetFollowers() {
    followers.clear();
    isLoadingFollowings.value = false;
    page.value = 0;
    reachedEndofFollowers.value = false;
  }

  void resetFollowings() {
    followings.clear();
    isLoadingFollowers.value = false;
    followingsPage.value = 0;
    reachedEndofFollowings.value = false;
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
    if (userProfile.value.username != username) {
      resetFollowers();
      resetFollowings();
    }
    try {
      isLoading.value = true;
      isConnected.value = true;
      if (!await connectionChecker.isConnected) {
        throw NetworkException(
            "Looks like there is problem with your connection.");
      }
      String cacheKey = username;

      if (userProfileCacheService.value.isInCache(cacheKey)) {
        final res = userProfileCacheService.value.getFromCache(cacheKey);
        userProfile.value = res;
        isLoading.value = false;
      } else {
        final res = await apiService.value.fetchUserProfile(userName: username);
        res.username = username;
        userProfile.value = res;
        isLoading.value = false;
        //  start reputation loading indicator
        isLoadingReputation.value = true;
        final userProfileReputation =
            await getUserReputation(userId: res.userId!);
        res.mpxr = userProfileReputation.mpxr!.toDouble();

        userProfile.value = res;

        // cache the user profile ;
        userProfileCacheService.value.addToCache(cacheKey, userProfile.value);
        isLoadingReputation.value = false;
      }
      //  end loading indicator and show it on the front end
    } catch (e) {
      if (e is NetworkException) {
        isConnected.value = false;
        Toster(
            message: 'No Internet Connection', color: Colors.red, duration: 1);
      }
    }
  }

  Future<UserProfileReputation> getUserReputation({required int userId}) async {
    UserProfileReputation userProfileReputation =
        await userProfileApiService.value.getUserReputation(userId: userId);

    return userProfileReputation;
  }

  Future<void> fetchFollowers({required String username}) async {
    isLoadingFollowers.value = true;
    page.value += 1;

    List<dynamic> fetchedFollowers = await apiService.value
        .fetchUserFollowers(page: page.value, username: username);

    followers.addAll(fetchedFollowers);
    if (fetchedFollowers.length < 10) reachedEndofFollowers.value = true;
    isLoadingFollowers.value = false;
    firstTimeLoading.value = false;
  }

  Future<void> fetchFollowings({required String username}) async {
    isLoadingFollowings.value = true;
    followingsPage.value += 1;

    List<dynamic> fetchedFollowings = await apiService.value
        .fetchUserFollowings(page: followingsPage.value, username: username);

    followings.addAll(fetchedFollowings);
    if (fetchedFollowings.length < 10) reachedEndofFollowings.value = true;
    isLoadingFollowings.value = false;
    firstTimeLoadingFollowings.value = false;
  }

  Future<void> sendFollowRequest({
    required String userName,
  }) async {
    isSendingFollowRequest.value = true;

    try {
      if (!await connectionChecker.isConnected) {
        throw NetworkException(
            "Looks like there is problem with your connection.");
      }

      bool isFollowing = userProfile.value.isFollowing!.value;
      if (isFollowing) {
        await unfollowUser(userName);
      } else {
        await followUser(userName);
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

    isSendingFollowRequest.value = false;
  }

  Future<void> sendFriendRequest({required String username}) async {
    isSendingFriendRequest.value = true;

    isSendingFriendRequest.value = false;
  }

  Future<void> followUser(String userName) async {
    if (await apiService.value.followUser(userName)) {
      userProfile.value.isFollowing!.value = true;
    }
  }

  Future<void> unfollowUser(String userName) async {
    if (await apiService.value.unfollowUser(userName)) {
      userProfile.value.isFollowing!.value = false;
    }
  }
}
