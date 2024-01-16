import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/user_profile_displays/view/widgets/blog_card.dart';
import 'package:mindplex/features/user_profile_displays/controllers/bookmarksController.dart';

import 'package:mindplex/features/blogs/view/widgets/blog_shimmer.dart';
import "package:mindplex/utils/status.dart";

class BookmarkScreen extends StatelessWidget {
  BookmarkScreen({super.key});

  final BookmarksController bookmarkController = Get.put(BookmarksController());
  @override
  Widget build(BuildContext context) {
    bookmarkController.loadBlogs();
    return Container(
      child: Obx(() {
        return bookmarkController.status == Status.loading
            ? ListView.builder(
                itemCount: 3,
                itemBuilder: (ctx, inx) => const BlogSkeleton(),
              )
            : bookmarkController.status == Status.error
                ? Center(
                    child: Icon(Icons.error),
                  )
                : Column(children: [
                    Expanded(
                        child: ListView.separated(
                            controller: bookmarkController.scrollController,
                            itemCount: bookmarkController.blogs.length + 1,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              if (bookmarkController.status ==
                                      Status.loadingMore &&
                                  index == bookmarkController.blogs.length) {
                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: 3,
                                  itemBuilder: (ctx, inx) =>
                                      const BlogSkeleton(),
                                );
                              } else if (bookmarkController.status !=
                                      Status.loadingMore &&
                                  index == bookmarkController.blogs.length) {
                                return SizedBox(height: 10);
                              }

                              return BlogCard(
                                  blog: bookmarkController.blogs[index],
                                  index: index);
                            })),
                  ]);
      }),
    );
  }
}


// email: email@mindplex.ai
// password: QQ!!qq11QQ!!qq11
