import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/blogs/services/blog_api_service.dart';

import '../../../utils/Toster.dart';

class BlogTimeSpentController extends GetxController{
  RxBool isBlogViewed = false.obs;
  Timer? blogViewTimer;
  Timer? userViewTimer;
  RxInt totalMinutesOnBlog = 0.obs;
  RxInt totalMinutesToReadBlog = 0.obs;

  ScrollController scrollController = ScrollController();

  BlogApiService blogApiService = BlogApiService();

  @override
  void onInit() {
    super.onInit();

    scrollController.addListener(() {
      print(scrollController.position.maxScrollExtent);
      print(scrollController.position.pixels);
      if (scrollController.position.pixels >= (scrollController.position.maxScrollExtent-125)) {
        // Load more data
        print("you have viewed all of the blog");
      }
      else if (scrollController.position.pixels >= (scrollController.position.maxScrollExtent * 2 / 3)) {
        // Load more data
        print("you have viewed 2/3 of the blog");
      }
      else if (scrollController.position.pixels >= (scrollController.position.maxScrollExtent / 3)) {
        // Load more data
        print("you have viewed 1/3 of the blog");
      }
    });
  }

  void startOrStopTimer(String? blogSlug,int? minutesToRead,bool start) {

    if (start) {
      totalMinutesOnBlog.value = minutesToRead!;
      blogViewTimer = Timer(Duration(seconds: 15), () {
        addView(blogSlug!);
      });
      userViewTimer = Timer.periodic(Duration(minutes: 1), (timer) {
        if(totalMinutesOnBlog < minutesToRead!) {
          totalMinutesOnBlog++;
          Toster(message: "$totalMinutesOnBlog minute spent on this blog");
        }
        else{
          userViewTimer?.cancel();
        }
      });
    }
    else {
      blogViewTimer?.cancel();
      userViewTimer?.cancel();
    }
  }
  void addView(String blogSlug) async {
    bool success = await blogApiService.AddView(blogSlug);
    if(success){
      Toster(message: "this blog is now viewed");
    }
}
}