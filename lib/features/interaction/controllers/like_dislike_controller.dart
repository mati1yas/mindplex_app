import 'package:dio/dio.dart';
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

  int? lastVotedBlogIndex;
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
      } else {
        print('object');
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
    try {
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
        // blogsController.blogs[index] = blog;
      }
    } catch (e) {
      Toster(
          message: 'Failed To Submit Reaction', color: Colors.red, duration: 1);
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

  Future<void> addVote(
      {required int blogIndex,
      required Blog blog,
      required String articleSlug}) async {
    final BlogsController blogsController = Get.find();
    if (blog.isVotted.value == true) {
      Toster(
          message: voteMessageForSameArticle,
          color: Color.fromARGB(255, 33, 89, 118),
          duration: 3);
    } else if (blog.isVotted.value == false || lastVotedBlogIndex != null) {
      Toster(
          message: voteMessageForDifferentArticle,
          color: Color.fromARGB(255, 33, 89, 118),
          duration: 3);
    } else if (blog.isVotted.value == null) {
      try {
        await apiService.value.addVote(
          articleSlug: blog.slug ?? '',
          isVoted: true,
        );
        blog.isVotted.value = true;
        hasVoted.value = true;

        if (lastVotedBlogIndex != null &&
            lastVotedBlogIndex! < blogsController.blogs.length) {
          blogsController.blogs[lastVotedBlogIndex!].isVotted.value = false;
        }

        lastVotedBlogIndex = blogIndex;

        blogsController.blogs[blogIndex] = blog;
      } catch (e) {
        if (e is NetworkException) {
          isConnected.value = false;
          Toster(
              message: 'No Internet Connection',
              color: Colors.red,
              duration: 1);
        }
      }
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

    try {
      apiService.value.removePreviousInteraction(
          articleSlug: articleSlug, interction: interction);

      if (blog.isUserLiked.value == true && interction == "L") {
        blog.likes.value -= 1;
      }

      blog.isUserDisliked.value = false;
      blog.isUserLiked.value = false;
      blogsController.blogs[index] = blog;
    } on DioException catch (e) {
      Toster(
          message: 'Failed To Submit Reaction', color: Colors.red, duration: 1);
    } catch (e) {
      try {
        apiService.value.removePreviousInteraction(
            articleSlug: articleSlug, interction: interction);

        if (blog.isUserLiked.value == true && interction == "L") {
          blog.likes.value -= 1;
        }

        blog.isUserDisliked.value = false;
        blog.isUserLiked.value = false;
        // blogsController.blogs[index] = blog;
      } catch (e) {
        if (e is DioException)
          Toster(
              message: 'Failed To Submit Reaction',
              color: Colors.red,
              duration: 1);
      }
    }
  }

  Future<void> followUnfollowBlogAuthor(
      {required int blogIndex,
      required int authorIndex,
      required Blog blog,
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
            blogIndex: blogIndex,
            authorIndex: authorIndex,
            userName: userName,
            blog: blog);
      } else {
        await followBlogAuthor(
            blogIndex: blogIndex,
            authorIndex: authorIndex,
            userName: userName,
            blog: blog);
      }
    } catch (e) {
      if (e is NetworkException) {
        isConnected.value = false;
        Toster(
            message: 'No Internet Connection', color: Colors.red, duration: 1);
      } else {
        Toster(
            message: 'Failed To Follow/Unfollow',
            color: Colors.red,
            duration: 1);
      }
    }
    clickedAuthorIndex.value = -1;

    isSendingFollowRequest.value = false;
  }

  Future<void> followBlogAuthor(
      {required int blogIndex,
      required int authorIndex,
      required String userName,
      required Blog blog}) async {
//  -1 means the follow/unfollow action is not sent from blog detail page instead it is from profile page .
    if (await apiService.value.followUser(userName)) {
      if (blogIndex != -1) blog.authors![authorIndex].isFollowing!.value = true;
    }
  }

  Future<void> unfollowBlogAuthor(
      {required int blogIndex,
      required int authorIndex,
      required String userName,
      required Blog blog}) async {
    if (await apiService.value.unfollowUser(userName)) {
//  -1 means the follow/unfollow action is not sent from blog detail page instead it is from profile page .
      if (blogIndex != -1)
        blog.authors![authorIndex].isFollowing!.value = false;
    }
  }
}
