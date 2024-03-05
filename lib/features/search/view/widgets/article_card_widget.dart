import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/authentication/controllers/auth_controller.dart';
import 'package:mindplex/features/drawer/view/widgets/top_user_profile_icon.dart';
import 'package:mindplex/features/search/controllers/search_controller.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';

import '../../../../routes/app_routes.dart';
import '../../../../utils/colors.dart';
import '../../../blogs/view/screens/blog_detail_page.dart';

class ArticleCard extends StatelessWidget {
  ArticleCard({
    super.key,
    required this.searchController,
    required this.index,
  });

  final SearchPageController searchController;
  final int index;
  AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Get.to(DetailsPage(
            index: index, details: searchController.popularBlogs[index]));
      },
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white),
            color: blogContainerColor),
        child: Container(
          width: width * 0.65,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: searchController
                                      .popularBlogs[index].thumbnailImage ==
                                  "default.jpg"
                              ? searchController
                                          .popularBlogs[index].postTypeFormat ==
                                      "text"
                                  ? DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          "assets/images/img_not_found_text.png"))
                                  : DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          "assets/images/image_not_found_podcast.png"))
                              : DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(searchController
                                      .popularBlogs[index].thumbnailImage!))),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
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
                          searchController.popularBlogs[index].authorAvatar ??
                              ""),
                      radius: 15,
                      backgroundColor: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: width * 0.2,
                            child: Text(
                              searchController
                                      .popularBlogs[index].authorDisplayName ??
                                  "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            searchController.popularBlogs[index].publishedAt ??
                                "",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Obx(
                        () => searchController.loadingReputation.value &&
                                index >= searchController.startPosition.value
                            ? Container(
                                width: 13,
                                height: 13,
                                child: CircularProgressIndicator(
                                  color: Colors.green[300],
                                ))
                            : Text(
                                "MPXR ${searchController.popularBlogs[index].reputation.value != null ? searchController.popularBlogs[index].reputation.value!.author!.mpxr!.toStringAsFixed(2) : "-"}",
                                style: TextStyle(
                                    color: titleTextColor,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ],
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
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      searchController.popularBlogs[index].overview ?? ""),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Obx(
                      () => searchController.loadingReputation.value &&
                              index >= searchController.startPosition.value
                          ? Container(
                              width: 13,
                              height: 13,
                              child: CircularProgressIndicator(
                                color: Colors.green[300],
                              ))
                          : Text(
                              "MPXR ${searchController.popularBlogs[index].reputation.value != null ? searchController.popularBlogs[index].reputation.value!.postRep!.toStringAsFixed(5) : "-"}",
                              style: TextStyle(
                                  color: titleTextColor,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ],
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
                      searchController.popularBlogs[index].views.toString() +
                          " Views",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
