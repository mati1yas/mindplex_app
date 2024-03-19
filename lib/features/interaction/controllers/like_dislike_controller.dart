import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/blogs/controllers/blogs_controller.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';
import 'package:mindplex/services/api_services.dart';
import 'package:mindplex/utils/Toster.dart';
import 'package:mindplex/utils/constatns.dart';
import 'package:mindplex/utils/network/connection-info.dart';

class LikeDislikeConroller extends GetxController {
  RxBool isLoading = true.obs;
  final apiService = ApiService().obs;
  RxBool showEmoji = false.obs;
  RxBool reactedWithEmoji = false.obs;
  RxBool hasVoted = false.obs;
  RxBool hasBookMarked = false.obs;
  RxList currentEmoji = [
    "😅",
  ].obs;
  RxBool isSendingFollowRequest = false.obs;
  RxBool isConnected = false.obs;
  RxInt clickedAuthorIndex = (-1).obs;
  ConnectionInfoImpl connectionChecker = Get.find();

  Future<void> interactionHandler(
      {required Blog blog, required int index, required bool itIsLike}) async {
    if (!itIsLike) {
      if (blog.isUserDisliked.value == true) {
        removePreviousInteraction(
            blog: blog,
            index: index,
            articleSlug: blog.slug ?? "",
            interction: "D");
      } else if (blog.isUserDisliked.value == false) {
        likeDislikeArticle(
            blog: blog,
            index: index,
            articleSlug: blog.slug ?? "",
            interction: "D");
      }
    } else {
      if (blog.isUserLiked.value == true) {
        removePreviousInteraction(
            blog: blog,
            index: index,
            articleSlug: blog.slug ?? "",
            interction: "L");
      } else if (blog.isUserLiked.value == false) {
        likeDislikeArticle(
            blog: blog,
            index: index,
            articleSlug: blog.slug ?? "",
            interction: "L");
      }
    }
  }

  Future<void> likeDislikeArticle(
      {required int index,
      required Blog blog,
      required String articleSlug,
      required String interction}) async {
    apiService.value
        .likeDislikeArticle(articleSlug: articleSlug, interction: interction);
    final BlogsController blogsController = Get.find();

// logic for incrementing and decrmenting like and dislike counter realtime
    if (blog.isUserLiked.value == true && interction == "D") {
      blog.likes.value -= 1;
    } else if (blog.isUserDisliked.value == true && interction == "L") {
      blog.likes.value += 1;
    } else if (blog.isUserDisliked.value == false &&
        blog.isUserLiked.value == false) {
      if (interction == "L") {
        blog.likes.value += 1;
      }
    }

    if (interction == "D") {
      blog.isUserDisliked.value = true;

      blog.isUserLiked.value = false;

      blogsController.blogs[index] = blog;
    } else {
      blog.isUserDisliked.value = false;
      blog.isUserLiked.value = true;
      blogsController.blogs[index] = blog;
    }
  }

  void reactWithEmoji({
    required int emojiIndex,
    required int blogIndex,
    required Blog blog,
  }) {
    final BlogsController blogsController = Get.find();

    apiService.value.reactWithEmoji(
      articleSlug: blog.slug ?? "",
      emoji_value: emojiCodes[emojiIndex],
    );

    blog.interactedEmoji.value = emojiCodes[emojiIndex];
    showEmoji.value = !showEmoji.value;
    blogsController.blogs[blogIndex] = blog;
  }

  // Future<void> addVote({
  //   required int blogIndex,
  //   required Blog blog,
  // }) async {
  //   apiService.value.addVote(
  //     articleSlug: blogIndex,
  //     hasVoted: hasVoted.value,
  //   );
  //   final BlogsController blogsController = Get.find();
  //   blog.isVotted.value = !(blog.isVotted.value ?? false);
  //   hasVoted.value = !hasVoted.value;
  //   blogsController.blogs[blogIndex] = blog;

  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final String? lastVoted = prefs.getString('lastVoted');
  //   final DateTime now = DateTime.now();
  //   final String month = now.month.toString();
  //   final String year = now.year.toString();
  //   final String currentMonth = "$month-$year";
  //   if (lastVoted == null || lastVoted != currentMonth) {
  //     prefs.setString('lastVoted', currentMonth);
  //     hasVoted.value = true;
  //   } else {
  //     Get.snackbar(
  //       'Already Voted',
  //       'You have already voted or there is an issue with the vote status.',
  //       snackPosition: SnackPosition.BOTTOM,
  //       duration: Duration(seconds: 3),
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //     hasVoted.value = false;
  //   }
  // }
  Future<void> addVote(
      {required int blogIndex,
      required Blog blog,
      required String articleSlug}) async {
    final BlogsController blogsController = Get.find();
    if (blog.isVotted.value == null) {
      await apiService.value.addVote(
        articleSlug: blog.slug ?? '',
        hasVoted: true,
      );
      blog.isVotted.value = true;
      hasVoted.value = true;
      blogsController.blogs[blogIndex] = blog;
    } else if (blog.isVotted.value == true) {
      blog.isVotted.value = true;
      hasVoted.value = true;
      blogsController.blogs[blogIndex] = blog;
    } else {
      blog.isVotted.value = false;
      hasVoted.value = false;
      blogsController.blogs[blogIndex] = blog;

      Get.snackbar(
          "Voting value", "You have already voted on a different article.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.black,
          duration: Duration(seconds: 10));
    }
  }

  Future<void> addToBookmark({
    required int blogIndex,
    required Blog blog,
    required String articleSlug,
  }) async {
    apiService.value.addToBookmark(
        articleSlug: blog.slug ?? '', hasBookmarked: hasBookMarked.value);

    final BlogsController blogsController = Get.find();

    blog.isBookmarked?.value = !(blog.isBookmarked?.value ?? false);
    hasBookMarked.value = !hasBookMarked.value;
    blogsController.blogs[blogIndex] = blog;
  }

  Future<void> removePreviousInteraction(
      {required int index,
      required Blog blog,
      required String articleSlug,
      required String interction}) async {
    final BlogsController blogsController = Get.find();

    apiService.value.removePreviousInteraction(
        articleSlug: articleSlug, interction: interction);

    if (blog.isUserLiked.value == true && interction == "L") {
      blog.likes.value -= 1;
    }

    blog.isUserDisliked.value = false;
    blog.isUserLiked.value = false;
    blogsController.blogs[index] = blog;
  }

  Future<void> followUnfollowBlogAuthor(
      {required int blogIndex,
      required int authorIndex,
      required String userName,
      required bool isFollowing}) async {
    isSendingFollowRequest.value = true;
    clickedAuthorIndex.value = authorIndex;
    try {
      if (!await connectionChecker.isConnected) {
        throw NetworkException(
            "Looks like there is problem with your connection.");
      }
      if (isFollowing) {
        await unfollowBlogAuthor(
            blogIndex: blogIndex, authorIndex: authorIndex, userName: userName);
      } else {
        await followBlogAuthor(
            blogIndex: blogIndex, authorIndex: authorIndex, userName: userName);
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
    clickedAuthorIndex.value = -1;

    isSendingFollowRequest.value = false;
  }

  Future<void> followBlogAuthor({
    required int blogIndex,
    required int authorIndex,
    required String userName,
  }) async {
    final BlogsController blogsController = Get.find();
//  -1 means the follow/unfollow action is not sent from blog detail page instead it is from profile page .

    if (await apiService.value.followUser(userName)) {
      if (blogIndex != -1)
        blogsController.filteredBlogs[blogIndex].authors![authorIndex]
            .isFollowing!.value = true;
    }
  }

  Future<void> unfollowBlogAuthor({
    required int blogIndex,
    required int authorIndex,
    required String userName,
  }) async {
    final BlogsController blogsController = Get.find();

    if (await apiService.value.unfollowUser(userName)) {
//  -1 means the follow/unfollow action is not sent from blog detail page instead it is from profile page .
      if (blogIndex != -1)
        blogsController.filteredBlogs[blogIndex].authors![authorIndex]
            .isFollowing!.value = false;
    }
  }
}
