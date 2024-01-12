import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';
import 'package:mindplex/features/user_profile_displays/view/widgets/blog_shimmer.dart';
import '../../controllers/BlogsType.dart';
import "../widgets/blog-widget.dart";
import "../../../../utils/status.dart";

class PublishedPosts extends StatelessWidget {
  PublishedPosts({super.key});

  ProfileController userProfileController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(() {
        return userProfileController.status == Status.loading
            ? ListView.builder(
                itemCount: 3,
                itemBuilder: (ctx, inx) => const BlogSkeleton(),
              )
            : userProfileController.status == Status.error
                ? Center(
                    child: Icon(Icons.error),
                  )
                : ListView.separated(
                    controller: userProfileController.scrollController,
                    itemCount: userProfileController.profileBlogs.length + 1,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      if (userProfileController.status == Status.loadingMore &&
                          index == userProfileController.profileBlogs.length) {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (ctx, inx) => const BlogSkeleton(),
                        );
                      } else if (userProfileController.status !=
                              Status.loadingMore &&
                          index == userProfileController.profileBlogs.length) {
                        return SizedBox(height: 10);
                      }

                      return BlogWidget(
                          publishedPost:
                              userProfileController.profileBlogs[index]);
                    });
      }),
    );
  }
}


// email: email@mindplex.ai
// password: QQ!!qq11QQ!!qq11
