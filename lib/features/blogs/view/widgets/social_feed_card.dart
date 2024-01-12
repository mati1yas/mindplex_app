import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';
import 'package:mindplex/features/blogs/view/widgets/interaction_statistics_widget.dart';

import '../../../../routes/app_routes.dart';
import '../../../authentication/controllers/auth_controller.dart';
import '../../controllers/blogs_controller.dart';
import 'blog_content_display.dart';

class SocialFeedCard extends StatelessWidget {
  SocialFeedCard(
      {super.key, required this.blogsController, required this.index});
  final BlogsController blogsController;
  final int index;

  AuthController authController = Get.find();
  @override
  Widget build(BuildContext context) {
    Blog blog = blogsController.filteredBlogs[index];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.greenAccent),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                //  will be modified in detail
                //
                if (authController.isGuestUser.value) {
                  authController.guestReminder(context);
                } else {
                  Get.toNamed(AppRoutes.profilePage, parameters: {
                    "me": "notme",
                    "username":
                        blogsController.filteredBlogs[index].authorUsername ??
                            ""
                  });
                }
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    blogsController.filteredBlogs[index].authorAvatar ?? ""),
                radius: 20,
                backgroundColor: Colors.black,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(blog.authorDisplayName ?? "",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700)),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.timer_outlined,
                        color: Colors.white,
                      )
                    ],
                  ),
                  Text(
                    "MPXR 0.324",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        blog.publishedAt ?? "",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.tag_faces_outlined,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Interactions",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    "Post MPXR 0.94",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.white,
                  ),
                  Material(
                    color: Color(0xFF0c2b46),
                    child: BlogContentDisplay(
                      data: blogsController.filteredBlogs[index].content ?? [],
                      padding: 0.0,
                    ),
                  ),
                  InteractionStatistics(
                      blogsController: blogsController, index: index)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
