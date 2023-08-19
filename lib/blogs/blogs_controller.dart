import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mindplex_app/models/blog_model.dart';
import 'package:mindplex_app/services/api_services.dart';

class BlogsController extends GetxController {
  RxBool isLoading = true.obs;

  RxString recommender = "default".obs;
  RxString post_format = "text".obs;
  RxInt page = 1.obs;
  RxList<Blog> blogs = <Blog>[].obs;
  final apiSerivice = ApiSerivice().obs;
  final categories = ['All', 'Popular', 'Most Recent', 'Trending'];

  final recommenderMaps = {
    'All': 'default',
    'Popular': 'popularity',
    'Most Recent': 'recent',
    'Trending': 'trending'
  };

  ScrollController scrollController = ScrollController();
  bool reachedEndOfList = false;

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
  }

  void loadMoreBlogs() async {
    if (isLoading.value || reachedEndOfList) {
      return;
    }

    isLoading.value = true;
    page.value++; // Increment the page number

    final res = await apiSerivice.value.loadBlogs(
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

  void fetchBlogs() async {
    isLoading.value = true;
    final res = await apiSerivice.value.loadBlogs(
        recommender: recommender.value,
        post_format: post_format.value,
        page: page.value.toInt());

    blogs.value = res;
    isLoading.value = false;
  }

  void filterBlogsByRecommender({required String category}) {
    reachedEndOfList = false;
    page.value = 1;
    recommender.value = recommenderMaps[category] as String;
    fetchBlogs();
  }

  void filterBlogsByPostType({required String postType}) {
    reachedEndOfList = false;
    page.value = 1;
    post_format.value = postType;
    fetchBlogs();
  }

  List<Blog> get filteredBlogs {
    return blogs;
  }
}
