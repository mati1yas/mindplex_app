import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/user_profile_displays/view/widgets/blog_shimmer.dart';
import '../../controllers/user_profile_controller.dart';
import "../widgets/blog-widget.dart";
import "../../../../utils/status.dart";

class PublishedPosts extends StatelessWidget {
  PublishedPosts({super.key});

  ProfileController profileController = Get.find();

  @override
  Widget build(BuildContext context) {
    profileController.loadPublishedPosts(page: 1);

    return Container(
      child: Obx(() {
        return profileController.status == Status.loading
            ? ListView.builder(
                itemCount: 3,
                itemBuilder: (ctx, inx) => const BlogSkeleton(),
              )
            : profileController.status == Status.error
                ? Center(
                    child: Icon(Icons.error),
                  )
                : ListView.separated(
                    controller: profileController.scrollPostsController,
                    itemCount: profileController.publishedPosts.length + 1,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      if (profileController.status == Status.loadingMore &&
                          index == profileController.publishedPosts.length) {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (ctx, inx) => const BlogSkeleton(),
                        );
                      } else if (profileController.status !=
                              Status.loadingMore &&
                          index == profileController.publishedPosts.length) {
                        return SizedBox(height: 10);
                      }

                      return BlogWidget(
                          publishedPost:
                              profileController.publishedPosts[index]);
                    });
      }),
    );
  }
}


// email: email@mindplex.ai
// password: QQ!!qq11QQ!!qq11
