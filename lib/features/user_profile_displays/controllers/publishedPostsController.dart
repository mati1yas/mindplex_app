import 'package:get/get.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';
import 'package:mindplex/features/user_profile_displays/controllers/BlogsController.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';

class PublishPostController extends BlogsController {
  @override
  void onInit() {
    super.onInit();
  }

  ProfileController profileController = Get.find<ProfileController>();

  @override
  Future<List<Blog>> fetchApi() async {
    List<Blog> res = await profileService.getPublisedPosts(
      username: profileController.userProfile.value.username!,
      page: blogPage.value,
    );
    return res;
  }
}
