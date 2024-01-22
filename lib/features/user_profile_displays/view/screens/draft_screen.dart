import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/blogs/controllers/blogs_controller.dart';
import 'package:mindplex/features/user_profile_displays/controllers/DraftedPostsController.dart';
import 'package:mindplex/features/user_profile_displays/view/widgets/blog_shimmer.dart';
import 'package:mindplex/features/user_profile_displays/view/widgets/DraftCard.dart';
import "../widgets/blog-widget.dart";
import "../../../../utils/status.dart";

class DraftPosts extends StatelessWidget {
  DraftPosts({super.key});

  final DraftedPostsController draftedPostsController =
      Get.put(DraftedPostsController());

  BlogsController blogsController = Get.find();

  @override
  Widget build(BuildContext context) {
    draftedPostsController.loadBlogs();
    return Container(
      child: Obx(() {
        return draftedPostsController.status == Status.loading
            ? ListView.builder(
                itemCount: 3,
                itemBuilder: (ctx, inx) => const BlogSkeleton(),
              )
            : draftedPostsController.status == Status.error
                ? Center(
                    child: Icon(Icons.error),
                  )
                : ListView.separated(
                    controller: draftedPostsController.scrollController,
                    itemCount: draftedPostsController.blogs.length + 1,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      if (draftedPostsController.status == Status.loadingMore &&
                          index == draftedPostsController.blogs.length) {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (ctx, inx) => const BlogSkeleton(),
                        );
                      } else if (draftedPostsController.status !=
                              Status.loadingMore &&
                          index == draftedPostsController.blogs.length) {
                        return SizedBox(height: 10);
                      }

                      return DraftCard(
                        draftedPostsController: draftedPostsController,
                        blog: draftedPostsController.blogs[index],
                      );
                    });
      }),
    );
  }
}


// email: email@mindplex.ai
// password: QQ!!qq11QQ!!qq11
