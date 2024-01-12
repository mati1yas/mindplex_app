import 'package:mindplex/features/blogs/models/blog_model.dart';
import './BlogsController.dart';

class BookmarksController extends BlogsController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<List<Blog>> fetchApi() async {
    List<Blog> res =
        await profileService.getBookmarkPosts(page: blogPage.value);
    return res;
  }
}
