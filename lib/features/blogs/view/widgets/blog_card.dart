import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/authentication/controllers/auth_controller.dart';
import 'package:mindplex/features/blogs/view/widgets/interaction_statistics_widget.dart';

import '../../controllers/blogs_controller.dart';
import '../../../../routes/app_routes.dart';
import '../screens/blog_detail_page.dart';

class BlogCard extends StatelessWidget {
  BlogCard({
    super.key,
    required this.blogsController,
    required this.index,
  });

  final BlogsController blogsController;
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
                        "username": blogsController
                                .filteredBlogs[index].authorUsername ??
                            ""
                      });
                    }
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        blogsController.filteredBlogs[index].authorAvatar ??
                            ""),
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
                      print("isFollowing " + blogsController.filteredBlogs[index].isFollowing!.value.toString());
                      Get.to(DetailsPage(
                          index: index,
                          details: blogsController.filteredBlogs[index]));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              blogsController
                                      .filteredBlogs[index].authorDisplayName ??
                                  "",
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
                              blogsController
                                      .filteredBlogs[index].publishedAt ??
                                  "",
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
                            blogsController.filteredBlogs[index].postTitle ??
                                ""),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            blogsController.filteredBlogs[index].overview ??
                                ""),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              blogsController.filteredBlogs[index].minToRead ??
                                  "",
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
                                      image: NetworkImage(blogsController
                                              .filteredBlogs[index]
                                              .thumbnailImage ??
                                          ""))),
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
                                          child: blogsController
                                                      .filteredBlogs[index]
                                                      .postTypeFormat ==
                                                  "text"
                                              ? const Icon(
                                                  Icons.description_outlined,
                                                  color: Color(0xFF8aa7da),
                                                  size: 20,
                                                )
                                              : blogsController
                                                          .filteredBlogs[index]
                                                          .postTypeFormat ==
                                                      "video"
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
                          blogsController: blogsController,
                          index: index,
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
