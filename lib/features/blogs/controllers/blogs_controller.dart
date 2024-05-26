import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/blogs/cache_service/blog_cache_service.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';
import 'package:mindplex/features/blogs/models/reputation_model.dart';
import 'package:mindplex/features/blogs/models/social_feed_setting_model.dart';
import 'package:mindplex/services/api_services.dart';
import 'package:mindplex/utils/Toster.dart';
import 'package:mindplex/utils/awesome_snackbar.dart';
import 'package:mindplex/utils/snackbar_constants.dart';

import '../../../utils/network/connection-info.dart';

class BlogsController extends GetxController {
  RxBool isLoadingMore = true.obs;
  RxBool newPostTypeLoading = true.obs;
  RxBool isConnected = true.obs;
  RxBool canLoadMoreBlogs = true.obs;

  RxString recommender = "default".obs;
  RxString post_format = "text".obs;
  RxString post_type = "articles".obs;
  RxInt page = 1.obs;
  RxList<Blog> blogs = <Blog>[].obs;
  RxBool loadingReputation = false.obs;
  RxBool showSocialFeedForm = true.obs;

  RxList<dynamic> topicPostCategories = <dynamic>[].obs;
  final Rx<SocialFeedSetting> socialFeedSetting =
      Rx<SocialFeedSetting>(SocialFeedSetting());

  ConnectionInfoImpl connectionChecker = Get.find();
  RxInt startPosition = 0.obs;

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
    'text': 'Magazine',
    'video': 'Watch',
    'audio': 'Podcast',
  };

  ScrollController scrollController = ScrollController();
  bool reachedEndOfList = false;
  final apiSerivice = ApiService().obs;
  final blogCacheService = BlogCacheService().obs;
  double scrollDistance = 0.0;
  double previousOffset = 0.0;
  double currentOffset = 0.0;

  ScrollDirection scrollDirection = ScrollDirection.forward;

  @override
  void onInit() {
    super.onInit();

    scrollController.addListener(() {
      animateFormAppearance();

      if (!reachedEndOfList &&
          scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 250) {
        loadMoreBlogs();
      }
    });
  }

  void animateFormAppearance() {
    currentOffset = scrollController.position.pixels;
    if (scrollDirection == scrollController.position.userScrollDirection) {
      scrollDistance = scrollDistance + (currentOffset - previousOffset).abs();

      if (scrollDistance >= 75) {
        if (scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          showSocialFeedForm.value = false;
        } else {
          showSocialFeedForm.value = true;
        }
      }
    } else {
      scrollDistance = 0.0;
      scrollDirection = scrollDirection == ScrollDirection.forward
          ? ScrollDirection.reverse
          : ScrollDirection.forward;
    }
    previousOffset = currentOffset;
  }

  Future<BuildContext> getContext() async {
    BuildContext? context = Get.context;
    return context!;
  }

  void loadMoreBlogs() async {
    try {
      canLoadMoreBlogs.value = true;
      if (!await connectionChecker.isConnected) {
        throw NetworkException(
            "Looks like there is problem with your connection.");
      }
      if (isLoadingMore.value || reachedEndOfList) {
        return;
      }
      String cacheKey =
          "${post_type.value}/${recommender.value}/${post_format.value}";

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
        startPosition.value = blogs.length;
        blogs.addAll(res);

        loadReputation(res);
        blogCacheService.value.addToCache(cacheKey, res);
      }

      isLoadingMore.value = false;

      update();
    } catch (e) {
      if (e is NetworkException) {
        canLoadMoreBlogs.value = false;
      }
    }
  }

  void changeTopics({required String topicCategory}) async {
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
    showSocialFeedForm.value = true;
    post_type.value = postType;
    post_format.value = postFormat;
    recommender.value = 'default';
    page.value = 1;
    fetchBlogs();
  }

  void fetchBlogs({bool refreshing = false}) async {
    try {
      isConnected.value = true;
      if (!await connectionChecker.isConnected) {
        throw NetworkException(
            "Looks like there is problem with your connection.");
      }
      newPostTypeLoading.value = true;
      isLoadingMore.value = true;
      canLoadMoreBlogs.value = true;

      startPosition.value = 0;
      String cacheKey =
          "${post_type.value}/${recommender.value}/${post_format.value}";

      if (!refreshing && blogCacheService.value.isInCache(cacheKey)) {
        final res = blogCacheService.value.getFromCache(cacheKey);
        page.value = (res.length ~/ 10) + 1;
        blogs.value = res;
        loadReputation(res);
        if (res.isEmpty) reachedEndOfList = true;
      } else {
        final res = await apiSerivice.value.loadBlogs(
            post_type: post_type.value,
            recommender: recommender.value,
            post_format: post_format.value,
            page: page.value.toInt());
        if (res.isEmpty) reachedEndOfList = true;

        blogs.value = res;
        loadReputation(res);
        blogCacheService.value.removeFromCache(cacheKey);
        if (post_type != "social")
          blogCacheService.value.addToCache(cacheKey, blogs);
      }

      isLoadingMore.value = false;
      newPostTypeLoading.value = false;
    } catch (e) {
      if (e is NetworkException) {
        isConnected.value = false;
        showSnackBar(
            context: await getContext(),
            title: SnackBarConstantTitle.failureTitle,
            message: SnackBarConstantMessage.noInternetConnection,
            type: "failure");
      } else {
        showSnackBar(
            context: await getContext(),
            title: SnackBarConstantTitle.failureTitle,
            message: SnackBarConstantMessage.unKnowenError,
            type: "failure");
      }
      isLoadingMore.value = false;
      canLoadMoreBlogs.value = false;
    }
    isLoadingMore.value = false;
    newPostTypeLoading.value = false;
  }

  Future<void> loadReputation(List<Blog> fetchedBlogs) async {
    loadingReputation.value = true;

    try {
      List<String> slugs =
          await fetchedBlogs.map((blog) => blog.slug!).toList();
      slugs.length;

      List<Reputation> reputations =
          await apiSerivice.value.loadReputation(slugs: slugs);

      assignReputationToBlog(
          fetchedBlogs: fetchedBlogs, reputations: reputations);
    } catch (e) {
      if (e is DioException) {
        showSnackBar(
            context: await getContext(),
            title: SnackBarConstantTitle.failureTitle,
            message: SnackBarConstantMessage.mpxrLoadingFailure,
            type: "failure");
      }
    }

    loadingReputation.value = false;
  }

  void assignReputationToBlog({
    required List<Blog> fetchedBlogs,
    required List<Reputation> reputations,
  }) {
    for (var i = 0; i < fetchedBlogs.length; i++) {
      for (var j = 0; j < reputations.length; j++) {
        if (fetchedBlogs[i].slug == reputations[j].postSlug) {
          fetchedBlogs[i].reputation.value = reputations[j];

          blogs[startPosition.value + i] = fetchedBlogs[i];

          update();
          break;
        }
      }
    }
  }

  void filterBlogsByRecommender({required String category}) {
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
    animateScrollPosition();
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

  void animateScrollPosition() {
    scrollController.jumpTo(0);
  }

  List<Blog> get filteredBlogs {
    return blogs;
  }
}
