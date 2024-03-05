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
  RxBool isGoodReader = false.obs;
  RxBool isAverageReader = false.obs;
  RxBool isBestReader = false.obs;

  ScrollController scrollController = ScrollController();

  BlogApiService blogApiService = BlogApiService();

  @override
  void onInit() {
    super.onInit();

    scrollController.addListener(() {
      if (scrollController.position.pixels >= (scrollController.position.maxScrollExtent-125)) {
        // Load more data
        print("you have viewed all of the blog");
        if(isAverageReader.value && totalMinutesOnBlog.value >= (totalMinutesToReadBlog.value)){
          print("you are a best Reader");
          isBestReader.value = true;
        }
        else if(isGoodReader.value && totalMinutesOnBlog.value >= 2 * (totalMinutesToReadBlog.value / 3)){
          isAverageReader.value = true;
          print("you are an average Reader");
        }
        else if(totalMinutesOnBlog.value >= (totalMinutesToReadBlog.value / 3)){
          isGoodReader.value = true;
          print("you are just a good Reader");
        }
      }
      else if (scrollController.position.pixels >= (scrollController.position.maxScrollExtent * 2 / 3)) {
        if(isGoodReader.value && totalMinutesOnBlog.value >= 2 * (totalMinutesToReadBlog.value / 3)){
          isAverageReader.value = true;
          print("you are an average Reader");
        }
        else if(totalMinutesOnBlog.value >= (totalMinutesToReadBlog.value / 3)){
          isGoodReader.value = true;
          print("you are just a good Reader");
        }
        print("you have viewed 2/3 of the blog");
      }
      else if (scrollController.position.pixels >= (scrollController.position.maxScrollExtent / 3)) {
        if(totalMinutesOnBlog.value >= (totalMinutesToReadBlog.value / 3)){
          isGoodReader.value = true;
          print("you are just a good Reader");
        }
        print("you have viewed 1/3 of the blog");
      }
    });
  }

  void startOrStopTimer(String? blogSlug,int? minutesToRead,bool start) {

    if (start) {
      totalMinutesToReadBlog.value = minutesToRead!;
      blogViewTimer = Timer(Duration(seconds: 15), () {
        addView(blogSlug!);
        isGoodReader.value = true;
      });
      userViewTimer = Timer.periodic(Duration(minutes: 1), (timer) {
        if(totalMinutesOnBlog.value < minutesToRead) {
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