import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/authentication/controllers/auth_controller.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';
import './interaction_statistics_widget.dart';

import '../../../../routes/app_routes.dart';
import 'package:mindplex/features/blogs/view/screens/blog_detail_page.dart';

class BlogCard extends StatelessWidget {
  BlogCard({
    super.key,
    required this.blog,
    required this.index,
  });

  final Blog blog;
  final int index;

  AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            Row(
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
                        "username": blog.authorUsername ?? ""
                      });
                    }
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(blog.authorAvatar ?? ""),
                    radius: 20,
                    backgroundColor: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      print(
                          "isFollowing " + blog.isFollowing!.value.toString());
                      Get.to(DetailsPage(index: index, details: blog));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              blog.authorDisplayName ?? "",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "MPXR 1.234",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              blog.publishedAt ?? "",
                              style: TextStyle(
                                color: Color.fromARGB(255, 123, 122, 122),
                              ),
                            ),
                            Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                            )
                          ],
                        ),
                        Text(
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            blog.postTitle ?? ""),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            blog.overview ?? ""),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              blog.minToRead ?? "",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "MPXR 12.123",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          blog.thumbnailImage ?? ""))),
                              height: 170,
                              width: 400,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 1, right: 8.0),
                                child: Container(
                                    height: 60,
                                    width: 35,
                                    margin: EdgeInsets.only(left: 10, top: 0),
                                    decoration: const BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(5),
                                          bottomRight: Radius.circular(5),
                                        )),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          child: blog.postTypeFormat == "text"
                                              ? const Icon(
                                                  Icons.description_outlined,
                                                  color: Color(0xFF8aa7da),
                                                  size: 20,
                                                )
                                              : blog.postTypeFormat == "video"
                                                  ? const Icon(
                                                      Icons.videocam,
                                                      color: Color.fromARGB(
                                                          255, 185, 127, 127),
                                                      size: 20,
                                                    )
                                                  : const Icon(
                                                      Icons.headphones,
                                                      color: Colors.green,
                                                      size: 20,
                                                    ),
                                        )
                                      ],
                                    )),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        InteractionStatistics(
                          blog: blog,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Divider(
              color: Colors.white,
              thickness: 1,
            )
          ],
        ),
      ),
    );
  }
}
