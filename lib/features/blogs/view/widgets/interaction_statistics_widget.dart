import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';
import 'package:mindplex/features/interaction/controllers/like_dislike_controller.dart';
import 'package:share/share.dart';

import '../../../comment/view/screens/comment.dart';
import '../../controllers/blogs_controller.dart';

class InteractionStatistics extends StatelessWidget {
  InteractionStatistics({
    super.key,
    required this.blogsController,
    required this.index,
    required this.buttonsInteractive,
  });
  final BlogsController blogsController;
  final int index;
  final bool buttonsInteractive;

  LikeDislikeConroller likeDislikeConroller = Get.find();

  @override
  Widget build(BuildContext context) {
    Blog blog = blogsController.filteredBlogs[index];

    var width = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (buttonsInteractive)
                  likeDislikeConroller.interactionHandler(
                      blog: blog, index: index, itIsLike: true);
              },
              child: blog.isUserLiked.value
                  ? Icon(
                      color: Colors.white,
                      Icons.thumb_up_off_alt_rounded,
                    )
                  : Icon(
                      color: Colors.white,
                      Icons.thumb_up_off_alt_outlined,
                      size: width * 0.05,
                    ),
            ),
            SizedBox(
              width: 3,
            ),
            Obx(
              () => Text(
                blog.likes.value.toString() + " Likes",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (buttonsInteractive)
                  Share.share(blog.url ?? "",
                      subject: 'Sharing blog to your media appearance');
              },
              child: Icon(
                color: Colors.white,
                Icons.share_outlined,
                size: width * 0.05,
              ),
            ),
            SizedBox(
              width: 3,
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            if (buttonsInteractive)
              Get.bottomSheet(
                  isScrollControlled: true,
                  ignoreSafeArea: false,
                  MyWidgetComment(
                      post_slug: blog.slug!,
                      comment_number: blog.comments.toString()));
          },
          child: Row(
            children: [
              Icon(
                color: Colors.white,
                Icons.mode_comment_outlined,
                size: width * 0.05,
              ),
              SizedBox(
                width: 3,
              ),
              Text(
                blogsController.filteredBlogs[index].comments.toString() +
                    " comments",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        GestureDetector(
            onTap: () {
              if (buttonsInteractive)
                likeDislikeConroller.interactionHandler(
                    blog: blogsController.filteredBlogs[index],
                    index: index,
                    itIsLike: false);
            },
            child: Row(
              children: [
                Obx(
                  () => blog.isUserDisliked.value
                      ? Icon(
                          color: Colors.white,
                          Icons.thumb_down,
                        )
                      : Icon(
                          color: Colors.white,
                          Icons.thumb_down_off_alt_outlined,
                          size: width * 0.05,
                        ),
                ),
                SizedBox(
                  width: 3,
                ),
                Text(
                  "Dislike",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            )),
      ],
    );
  }
}
