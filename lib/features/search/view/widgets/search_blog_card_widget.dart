import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mindplex/features/authentication/controllers/auth_controller.dart';
import 'package:mindplex/features/blogs/view/widgets/blog_thumbnail_image_widget.dart';
import 'package:mindplex/features/search/controllers/search_controller.dart';
import 'package:mindplex/utils/colors.dart';

import '../../../blogs/view/screens/blog_detail_page.dart';

import '../../../user_profile_settings/models/user_profile.dart';
import '../../../../routes/app_routes.dart';

class SearchBlogCard extends StatelessWidget {
  SearchBlogCard({
    super.key,
    required this.searchController,
    required this.index,
  });

  final SearchPageController searchController;
  final int index;
  AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                    if (authController.isGuestUser.value) {
                      authController.guestReminder(context);
                    } else {
                      Get.toNamed(AppRoutes.profilePage, parameters: {
                        "me": "notme",
                        "username": searchController
                                .popularBlogs[index].authorUsername ??
                            ""
                      });
                    }
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        searchController.searchedBlogs[index].authorAvatar ??
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
                      Get.to(DetailsPage(
                          index: index,
                          details: searchController.searchedBlogs[index]));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              searchController
                                      .searchedBlogs[index].authorDisplayName ??
                                  "",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Obx(() =>
                                searchController.loadingReputation.value &&
                                        index >=
                                            searchController.startPosition.value
                                    ? Container(
                                        width: 13,
                                        height: 13,
                                        child: CircularProgressIndicator(
                                          color: Colors.green[300],
                                        ))
                                    : Text(
                                        " MPXR ${searchController.searchResults[index].reputation.value != null ? searchController.searchResults[index].reputation.value!.author!.mpxr!.toStringAsFixed(2) : "-"}",
                                        style: TextStyle(
                                            color: titleTextColor,
                                            fontWeight: FontWeight.bold),
                                      )),
                            Spacer(),
                            Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                            )
                          ],
                        ),
                        Text(
                          searchController.searchedBlogs[index].publishedAt ??
                              "",
                          style: TextStyle(
                            color: Color.fromARGB(255, 123, 122, 122),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            searchController.searchedBlogs[index].postTitle ??
                                ""),
                        Text(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            searchController.searchedBlogs[index].overview ??
                                ""),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              searchController.searchedBlogs[index].minToRead ??
                                  "",
                              style: TextStyle(color: Colors.white),
                            ),
                            Spacer(),
                            Obx(
                              () => searchController.loadingReputation.value &&
                                      index >=
                                          searchController.startPosition.value
                                  ? Container(
                                      width: 13,
                                      height: 13,
                                      child: CircularProgressIndicator(
                                        color: Colors.green[300],
                                      ))
                                  : Text(
                                      " MPXR ${searchController.searchResults[index].reputation.value != null ? searchController.searchResults[index].reputation.value!.postRep!.toStringAsFixed(5) : "-"}",
                                      style: TextStyle(
                                          color: titleTextColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Stack(
                          children: [
                            BlogThumbnailImage(
                                blog: searchController.searchResults[index],
                                height: 170,
                                width: width * 0.8),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 1, right: 15.0),
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
                                          child: searchController
                                                      .searchedBlogs[index]
                                                      .postTypeFormat ==
                                                  "text"
                                              ? const Icon(
                                                  Icons.description_outlined,
                                                  color: Color(0xFF8aa7da),
                                                  size: 20,
                                                )
                                              : searchController
                                                          .searchedBlogs[index]
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
                        Row(
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
                                  searchController.searchedBlogs[index].likes
                                          .toString() +
                                      " Likes",
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
                                  searchController.searchedBlogs[index].comments
                                          .toString() +
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
