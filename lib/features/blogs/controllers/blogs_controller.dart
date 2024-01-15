import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';
import 'package:mindplex/services/api_services.dart';
import 'package:mindplex/utils/Toster.dart';

import '../../../utils/network/connection-info.dart';

class BlogsController extends GetxController {
  RxBool isLoadingMore = true.obs;
  RxBool newPostTypeLoading = true.obs;
  RxBool isConnected = true.obs;

  RxString recommender = "default".obs;
  RxString post_format = "text".obs;
  RxString post_type = "articles".obs;
  RxInt page = 1.obs;
  RxList<Blog> blogs = <Blog>[].obs;

  RxList<dynamic> topicPostCategories = <dynamic>[].obs;

  ConnectionInfoImpl connectionChecker = Get.find();

  final categories = [
    'All',
    'Popular',
    'Most Recent',
    'Trending',
    'Article',
    "Video",
    "Podcast"
  ];

  final recommenderMaps = {
    'All': 'default',
    'Popular': 'popularity',
    'Most Recent': 'recent',
    'Trending': 'trending',
    'Article': 'Article',
    "Video": "Video",
    "Podcast": "Podcast",
  };

  final postFormatMaps = {
    'text': 'Read',
    'video': 'Watch',
    'audio': 'Listen',
  };

  ScrollController scrollController = ScrollController();
  bool reachedEndOfList = false;
  final apiSerivice = ApiService().obs;

  @override
  void onInit() {
    super.onInit();

    // Future.delayed(Duration(seconds: 5), () {
    //   fetchBlogs();
    //   // Your code using anotherController here
    // });

    // Add a listener to the scrollController to detect when the user reaches the end of the list
    scrollController.addListener(() {
      if (!reachedEndOfList && scrollController.position.pixels >= scrollController.position.maxScrollExtent - 250) {
        // Load more data
        loadMoreBlogs();
      }
    });
  }

  void loadMoreBlogs() async {
    if (isLoadingMore.value || reachedEndOfList) {
      return;
    }

    isLoadingMore.value = true;
    page.value++; // Increment the page number
    final res = await apiSerivice.value.loadBlogs(
        post_type: post_type.value,
        recommender: recommender.value,
        post_format: post_format.value,
        page: page.value.toInt());

    if (res.isEmpty) {
      reachedEndOfList = true;
      // Notify the user that there are no more posts for now
      // You can display a message or handle it in your UI accordingly
    } else {
      blogs.addAll(res);
    }

    isLoadingMore.value = false;

    update(); // Trigger UI update
  }

  void changeTopics({required String topicCategory}) async {
    print(topicCategory);
    post_format.value = topicCategory;
    page.value = 1;
    fetchBlogs();
  }

  String landingPageHeader() {
    return post_type == 'social'
        ? "Social Feed"
        : post_type == 'news'
            ? "News"
            : post_type == 'community_content'
                ? "Community"
                : post_type == 'topics'
                    ? "Topics"
                    : postFormatMaps[post_format.value] ?? "";
  }

  void loadContents(String postType, String postFormat) async {
    post_type.value = postType;
    post_format.value = postFormat;
    recommender.value = 'default';
    page.value = 1;
    fetchBlogs();
  }

  void fetchBlogs() async {
    try {
      isConnected.value = true;
      if (!await connectionChecker.isConnected) {
        throw NetworkException("Looks like there is problem with your connection.");
      }
      newPostTypeLoading.value = true;
      isLoadingMore.value = true;

      final res = await apiSerivice.value.loadBlogs(
          post_type: post_type.value,
          recommender: recommender.value,
          post_format: post_format.value,
          page: page.value.toInt());
      if (res.isEmpty)
        reachedEndOfList = true;
      blogs.value = res;
      isLoadingMore.value = false;
      newPostTypeLoading.value = false;
    }
    catch(e){
      if(e is NetworkException){
        isConnected.value = false;
        Toster(message: 'No Internet Connection',color: Colors.red,duration: 1);
      }
    }
  }

  void filterBlogsByRecommender({required String category}) {
    print(category);
    reachedEndOfList = false;
    page.value = 1;

    if (["Article", "Video", "Podcast"].contains(category)) {
      Map<String, String> postMap = {
        'Article': 'text',
        "Video": "video",
        "Podcast": "audio",
      };
      recommender.value = 'default';
      post_format.value = postMap[category]!;
    } else if (post_type == 'community_content') {
      post_format.value = 'all';
      recommender.value = recommenderMaps[category] as String;
    } else {
      recommender.value = recommenderMaps[category] as String;
    }

    fetchBlogs();
  }

  void filterBlogsByPostType({required String postFormat}) {
    reachedEndOfList = false;
    page.value = 1;
    post_format.value = postFormat;
    post_type.value = 'articles';
    // recommender.value = 'default';
    fetchBlogs();
  }

  Future<List<dynamic>> getUserInteractions(
      {required String articleSlug}) async {
    final interactions =
        await apiSerivice.value.fetchUserInteractions(articleSlug: articleSlug);
    return interactions;
  }

  Future<List<dynamic>> getUserInteraction(
      {required String articleSlug, required String interactionType}) async {
    final interactions = await apiSerivice.value.fetchUserInteraction(
        articleSlug: articleSlug, interactionType: interactionType);
    return interactions;
  }

  List<Blog> get filteredBlogs {
    return blogs;
  }
}
