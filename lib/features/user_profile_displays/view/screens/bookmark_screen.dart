import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_profile_controller.dart';
import "../widgets/blog-widget.dart";
import "../../../../utils/status.dart";

class BookmarkScreen extends StatelessWidget {
  BookmarkScreen({super.key});

  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Container(child: Obx(() {
      return profileController.status == Status.loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : profileController.status == Status.error
              ? Center(
                  child: Text(profileController.errorMessage.value),
                )
              : ListView.separated(
                  itemCount: profileController.publishedPosts.length,
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return BlogWidget(
                        publishedPost: profileController.publishedPosts[index]);
                  });
    }));
  }
}
