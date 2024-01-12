import 'package:flutter/material.dart';

import '../../controllers/blogs_controller.dart';

class InteractionStatistics extends StatelessWidget {
  const InteractionStatistics({
    super.key,
    required this.blogsController,
    required this.index,
  });
  final BlogsController blogsController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                //  like logic will be here
              },
              child: Icon(
                color: Colors.white,
                Icons.thumb_up_off_alt_outlined,
              ),
            ),
            SizedBox(
              width: 3,
            ),
            Text(
              blogsController.filteredBlogs[index].likes.toString() + " Likes",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                //  share logic will be here
              },
              child: Icon(
                color: Colors.white,
                Icons.share_outlined,
              ),
            ),
            SizedBox(
              width: 3,
            ),
          ],
        ),
        Row(
          children: [
            Icon(
              color: Colors.white,
              Icons.mode_comment_outlined,
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
        Row(
          children: [
            GestureDetector(
              onTap: () {
                //  dislike logic will be here
              },
              child: Icon(
                color: Colors.white,
                Icons.thumb_down_off_alt_outlined,
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
        ),
      ],
    );
  }
}
