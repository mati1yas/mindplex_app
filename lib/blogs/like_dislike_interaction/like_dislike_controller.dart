import 'package:get/get.dart';
import 'package:mindplex_app/blogs/blogs_controller.dart';
import 'package:mindplex_app/models/blog_model.dart';
import 'package:mindplex_app/services/api_services.dart';

class LikeDislikeConroller extends GetxController {
  RxBool isLoading = true.obs;
  final apiService = ApiService().obs;
  Future<void> likeDislikeArticle(
      {required int index,
      required Blog blog,
      required String articleSlug,
      required String interction}) async {
    apiService.value
        .likeDislikeArticle(articleSlug: articleSlug, interction: interction);
    final BlogsController blogsController = Get.find();

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

  Future<void> removePreviousInteraction(
      {required int index,
      required Blog blog,
      required String articleSlug,
      required String interction}) async {
    final BlogsController blogsController = Get.find();

    apiService.value.removePreviousInteraction(
        articleSlug: articleSlug, interction: interction);

    blog.isUserDisliked.value = false;
    blog.isUserLiked.value = false;
    blogsController.blogs[index] = blog;
  }
}
