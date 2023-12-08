import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:mindplex_app/blogs/blogs_controller.dart';
import 'package:mindplex_app/models/blog_model.dart';
import 'package:mindplex_app/services/api_services.dart';

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

  void changeEmoji(String icon) {
    currentEmoji[0] = icon;
    showEmoji.value = !showEmoji.value;
    reactedWithEmoji.value = true;
  }

  void addVote() {
    hasVoted.value = !hasVoted.value;
  }

  void addToBookmark() {
    hasBookMarked.value = !hasBookMarked.value;
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
}
