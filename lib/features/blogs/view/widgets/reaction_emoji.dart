import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/blog_model.dart';
import '../../../../utils/constatns.dart';
import '../../../interaction/controllers/like_dislike_controller.dart';

class ReactionEmoji extends StatelessWidget {
  final int emojiIndex;
  final Blog blog;
  final int blogIndex;

  const ReactionEmoji(
      {super.key,
      required this.emojiIndex,
      required this.blog,
      required this.blogIndex});

  @override
  Widget build(BuildContext context) {
    LikeDislikeConroller likeDislikeConroller = Get.find();
    return GestureDetector(
      onTap: () {
        likeDislikeConroller.reactWithEmoji(
          emojiIndex: emojiIndex,
          blogIndex: blogIndex,
          blog: blog,
        );
      },
      child: Text(emojis[emojiIndex], style: TextStyle(fontSize: 30)),
    );
  }
}
