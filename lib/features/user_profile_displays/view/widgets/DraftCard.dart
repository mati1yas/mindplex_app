import 'package:flutter/material.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';
import 'package:mindplex/utils/colors.dart';

class DraftCard extends StatelessWidget {
  final Blog blog;

  const DraftCard({required this.blog});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: blogContainerColor,
        border: Border.all(color: profileGolden),
      ),
      height: 280,
      width: 140,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            blog.postTitle ?? "",
            style: TextStyle(
              color: profileGolden,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: Text(
            blog.overview ?? "",
            style: TextStyle(color: Colors.white),
          )),
          Row(
            children: [
              TextButton(
                child: Text(
                  'Edit Draft',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {},
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                width: 1,
                height: 15,
                color: Colors.grey,
              ),
              SizedBox(
                width: 5,
              ),
              TextButton(
                child: Text(
                  'Delete Draft',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 85, 85),
                  ),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
