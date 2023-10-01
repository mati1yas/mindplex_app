import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../like_dislike_interaction/like_dislike_controller.dart';

class ReactionEmoji extends StatelessWidget {
  final String emoji;

  const ReactionEmoji({super.key, required this.emoji});

  @override
  Widget build(BuildContext context) {
    LikeDislikeConroller likeDislikeConroller = Get.find();
    return GestureDetector(
      onTap: () {
        likeDislikeConroller.changeEmoji(emoji);
      },
      child: Text(emoji, style: TextStyle(fontSize: 30)),
    );
  }
}
