import 'dart:ffi';

import 'package:get/get.dart';
import 'package:mindplex/features/blogs/controllers/blogs_controller.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';
import 'package:mindplex/services/api_services.dart';
import 'package:mindplex/utils/constatns.dart';

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

  void addVote() {
    hasVoted.value = !hasVoted.value;
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
      int index, String userName, bool isFollowing) async {
    isSendingFollowRequest.value = true;
    if (isFollowing) {
      await unfollowBlogAuthor(index, userName);
    } else {
      await followBlogAuthor(index, userName);
    }
    isSendingFollowRequest.value = false;
  }

  Future<void> followBlogAuthor(int index, String userName) async {
    final BlogsController blogsController = Get.find();

    if (await apiService.value.followUser(userName)) {
      blogsController.filteredBlogs[index].isFollowing!.value = true;
    }
  }

  Future<void> unfollowBlogAuthor(int index, String userName) async {
    final BlogsController blogsController = Get.find();

    if (await apiService.value.unfollowUser(userName)) {
      blogsController.filteredBlogs[index].isFollowing!.value = false;
    }
  }
}
