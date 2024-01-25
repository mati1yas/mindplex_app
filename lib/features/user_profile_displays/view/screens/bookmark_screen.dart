import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/user_profile_displays/view/widgets/blog_card.dart';
import 'package:mindplex/features/user_profile_displays/controllers/bookmarksController.dart';

import 'package:mindplex/features/blogs/view/widgets/blog_shimmer.dart';
import "../../../../utils/status.dart";

class BookmarkScreen extends StatelessWidget {
  BookmarkScreen({super.key});

  BookmarksController bookmarksController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(() {
        return bookmarksController.status == Status.loading
            ? ListView.builder(
                itemCount: 3,
                itemBuilder: (ctx, inx) => const BlogSkeleton(),
              )
            : bookmarksController.status == Status.error
                ? Center(
                    child: Icon(Icons.error),
                  )
                : Column(children: [
                    Expanded(
                        child: ListView.separated(
                            controller:
                                bookmarksController.bookMarkScorllController,
                            itemCount: bookmarksController.blogs.length + 1,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              if (bookmarksController.status ==
                                      Status.loadingMore &&
                                  index == bookmarksController.blogs.length) {
                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: 3,
                                  itemBuilder: (ctx, inx) =>
                                      const BlogSkeleton(),
                                );
                              } else if (bookmarksController.status !=
                                      Status.loadingMore &&
                                  index == bookmarksController.blogs.length) {
                                return SizedBox(height: 10);
                              }

                              return BlogCard(
                                  blog: bookmarksController.blogs[index],
                                  index: index);
                            })),
                  ]);
      }),
    );
  }
}


// email: email@mindplex.ai
// password: QQ!!qq11QQ!!qq11
