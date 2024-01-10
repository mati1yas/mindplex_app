import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/search/controllers/search_controller.dart';

import '../../../../routes/app_routes.dart';
import '../../../../utils/colors.dart';
import '../../../blogs/view/screens/blog_detail_page.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({
    super.key,
    required this.searchController,
    required this.index,
  });

  final SearchPageController searchController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white),
          color: blogContainerColor),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.65,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(DetailsPage(
                    index: index,
                    details: searchController.popularBlogs[index]));
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(searchController
                                  .popularBlogs[index].thumbnailImage ??
                                  ""))),
                      height: 100,
                      width: 300,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 1, right: 8.0),
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
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: searchController.popularBlogs[index]
                                      .postTypeFormat ==
                                      "text"
                                      ? const Icon(
                                    Icons.description_outlined,
                                    color: Color(0xFF8aa7da),
                                    size: 20,
                                  )
                                      : searchController.popularBlogs[index]
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
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    //  will be modified in detail .

                    Get.toNamed(AppRoutes.profilePage, parameters: {
                      "me": "notme",
                      "username":
                      searchController.popularBlogs[index].authorUsername ??
                          ""
                    });
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        searchController.popularBlogs[index].authorAvatar ?? ""),
                    radius: 15,
                    backgroundColor: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  searchController.popularBlogs[index].authorDisplayName ?? "",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  searchController.popularBlogs[index].publishedAt ?? "",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    searchController.popularBlogs[index].postTitle ?? ""),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    searchController.popularBlogs[index].overview ?? ""),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(
                    searchController.popularBlogs[index].minToRead ?? "",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "19.9k views",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}