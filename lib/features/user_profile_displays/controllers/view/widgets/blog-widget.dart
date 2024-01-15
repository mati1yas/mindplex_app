import 'package:flutter/material.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';
import 'package:mindplex/utils/colors.dart';

class BlogWidget extends StatelessWidget {
  Blog publishedPost;
  BlogWidget({required this.publishedPost});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: blogContainerColor,
      ),
      height: 250,
      width: 140,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            publishedPost.publishedAt ?? "",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            publishedPost.postTitle ?? "",
            style: TextStyle(
              color: Color.fromARGB(255, 97, 255, 213),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: Text(
            publishedPost.overview ?? "",
            style: TextStyle(color: Colors.white),
          )),
          Row(
            children: [
              Text(
                publishedPost.minToRead ?? "",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "${publishedPost.views.toString()} k views" ?? "",
                style: TextStyle(color: Colors.white),
              )
            ],
          )
        ],
      ),
    );
  }
}
