import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/blogs/blogs_controller.dart';
import 'package:mindplex/profile/user_profile_controller.dart';

class PostTopics extends StatelessWidget {
  const PostTopics({
    super.key,
    required this.blogsController,
  });

  final BlogsController blogsController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
          height: 35,
          child: ListView.builder(
              itemCount: blogsController.topicPostCategories.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) {
                var topicName =
                    blogsController.topicPostCategories[index]['name'];
                var topicCategory =
                    blogsController.topicPostCategories[index]['slug'];
                return Obx(
                  () => GestureDetector(
                    onTap: () {
                      blogsController.changeTopics(
                          topicCategory: topicCategory);
                    },
                    child: Container(
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 8, bottom: 8),
                        decoration: BoxDecoration(
                            // color: Colors.green,
                            borderRadius: BorderRadius.circular(20),
                            border: blogsController.post_format.value ==
                                    topicCategory
                                ? Border.all(color: Colors.green)
                                : Border.all(color: Colors.white)),
                        child: Center(
                          child: Text(
                            blogsController.topicPostCategories[index]['name'],
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                  ),
                );
              })),
    );
  }
}
