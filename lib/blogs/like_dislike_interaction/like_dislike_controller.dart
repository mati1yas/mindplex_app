import 'package:get/get.dart';
import 'package:mindplex_app/services/api_services.dart';

class LikeDislikeConroller extends GetxController {
  RxBool isLoading = true.obs;
  final apiService = ApiService().obs;
  Future<void> likeDislikeArticle(
      {required String articleSlug, required String interction}) async {
    apiService.value
        .likeDislikeArticle(articleSlug: articleSlug, interction: interction);
  }
}
