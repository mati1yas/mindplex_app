import 'package:get/get.dart';
import 'package:mindplex_app/models/blog_model.dart';
import 'package:mindplex_app/services/api_services.dart';

class BlogsController extends GetxController {
  RxBool isLoading = true.obs;

  RxString recommender = "default".obs;
  RxString post_format = "text".obs;
  RxInt page = 1.obs;
  RxList<Blog> blogs = <Blog>[].obs;
  final apiSerivice = ApiService().obs;
  final categories = ['All', 'Popular', 'Most Recent', 'Trending'];

  final recommenderMaps = {
    'All': 'default',
    'Popular': 'popularity',
    'Most Recent': 'recent',
    'Trending': 'trending'
  };

  @override
  void onInit() {
    super.onInit();
    fetchBlogs();
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
    recommender.value = recommenderMaps[category] as String;
    fetchBlogs();
  }

  void filterBlogsByPostType({required String postType}) {
    post_format.value = postType;
    fetchBlogs();
  }

  List<Blog> get filteredBlogs {
    return blogs;
  }
}
