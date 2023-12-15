import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mindplex/models/blog_model.dart';
import 'package:mindplex/services/api_services.dart';

class BlogsController extends GetxController {
  RxBool isLoading = true.obs;

  RxString recommender = "default".obs;
  RxString post_format = "text".obs;
  RxString post_type = "articles".obs;
  RxInt page = 1.obs;
  RxInt searchPage = 1.obs;
  RxList<Blog> blogs = <Blog>[].obs;
  RxList<Blog> popularPosts = <Blog>[].obs;
  RxList<Blog> searchResults = <Blog>[].obs;
  RxString searchQuery = "".obs;
  final apiSerivice = ApiService().obs;
  final categories = ['All', 'Popular', 'Most Recent', 'Trending'];

  final recommenderMaps = {
    'All': 'default',
    'Popular': 'popularity',
    'Most Recent': 'recent',
    'Trending': 'trending'
  };

  final postFormatMaps = {
    'text': 'Read',
    'video': 'Watch',
    'audio': 'Listen',
  };

  ScrollController scrollController = ScrollController();
  bool reachedEndOfList = false;
  ScrollController searchScrollController = ScrollController();
  bool reachedEndOfListSearch = false;

  @override
  void onInit() {
    super.onInit();
    fetchBlogs();

    // Add a listener to the scrollController to detect when the user reaches the end of the list
    scrollController.addListener(() {
      if (!reachedEndOfList &&
          scrollController.position.pixels >=
              scrollController.position.maxScrollExtent) {
        // Load more data
        loadMoreBlogs();
      }
    });
    searchScrollController.addListener(() {
      if (!reachedEndOfListSearch &&
          searchScrollController.position.pixels >=
              searchScrollController.position.maxScrollExtent) {
        // Load more data
        loadMoreSearchResults(searchQuery.value);
      }
    });
  }

  void loadMoreBlogs() async {
    if (isLoading.value || reachedEndOfList) {
      return;
    }

    isLoading.value = true;
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

    isLoading.value = false;

    update(); // Trigger UI update
  }

  void loadMoreSearchResults(String query) async {
    if (isLoading.value || reachedEndOfListSearch) {
      return;
    }

    isLoading.value = true;
    searchPage.value++; // Increment the page number

    final res = await apiSerivice.value
        .fetchSearchResponse(query, searchPage.value.toInt());

    if (res.blogs!.isEmpty) {
      reachedEndOfListSearch = true;
      // Notify the user that there are no more posts for now
    } else {
      searchResults.addAll(res.blogs!);
    }

    isLoading.value = false;

    update(); // Trigger UI update
  }

  void loadArticles() async {
    isLoading.value = true;
    post_type.value = 'news';
    post_format.value = 'text';
    fetchBlogs();
  }

  void fetchBlogs() async {
    isLoading.value = true;
    final res = await apiSerivice.value.loadBlogs(
        post_type: post_type.value,
        recommender: recommender.value,
        post_format: post_format.value,
        page: page.value.toInt());

    blogs.value = res;
    isLoading.value = false;
  }

  void fetchPopularBlogs() async {
    final res = await apiSerivice.value.fetchSearchLanding();

    popularPosts.value = res.blogs!;
    isLoading.value = false;
  }

  void fetchSearchResults(String query) async {
    reachedEndOfListSearch = false;
    isLoading.value = true;
    searchPage.value = 1;
    final res = await apiSerivice.value
        .fetchSearchResponse(query, searchPage.value.toInt());
    if (res.blogs!.isEmpty) {
      reachedEndOfListSearch = true;
    }
    searchResults.value = res.blogs!;
    searchQuery.value = query;
    isLoading.value = false;
  }

  void filterBlogsByRecommender({required String category}) {
    reachedEndOfList = false;
    page.value = 1;
    recommender.value = recommenderMaps[category] as String;
    fetchBlogs();
  }

  void filterBlogsByPostType({required String postFormat}) {
    reachedEndOfList = false;
    page.value = 1;
    post_format.value = postFormat;
    post_type.value = 'articles';
    fetchBlogs();
  }

  List<Blog> get filteredBlogs {
    return blogs;
  }

  List<Blog> get popularBlogs {
    return popularPosts;
  }

  List<Blog> get searchedBlogs {
    return searchResults;
  }
}
