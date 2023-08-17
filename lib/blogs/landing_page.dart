import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex_app/blogs/blogs_controller.dart';
import 'package:mindplex_app/blogs/screens/blog_detail_page.dart';

import '../profile/user_profile_controller.dart';
import '../routes/app_routes.dart';

class LandingPage extends StatefulWidget {
  LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  BlogsController blogsController = Get.put(BlogsController());

  GlobalKey<ScaffoldState> _globalkey = GlobalKey<ScaffoldState>();

  ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    profileController.getAuthenticatedUser();
    return Scaffold(
      backgroundColor: Color(0xFF0c2b46),
      key: _globalkey,
      drawer: Drawer(
        child: BackdropFilter(
          blendMode: BlendMode.srcOver,
          filter: ImageFilter.blur(
              sigmaX: 13.0, sigmaY: 13.0, tileMode: TileMode.clamp),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF062f46), Color(0xFF1d253d)],
            )),
            child: ListView(
              padding: EdgeInsets.only(top: 20, left: 20),
              children: [
                Obx(
                  () => Container(
                    height: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 50,
                            width: 50,
                            margin:
                                EdgeInsets.only(top: 40, left: 10, bottom: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.green,
                              image: DecorationImage(
                                image: NetworkImage(profileController
                                        .authenticatedUser.value.image ??
                                    ""),
                              ),
                            ),
                            child: Container()),
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profileController
                                        .authenticatedUser.value.firstName ??
                                    " " +
                                        '${profileController.authenticatedUser.value.lastName}' ??
                                    " ",
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                profileController
                                        .authenticatedUser.value.username ??
                                    " ",
                                style:
                                    TextStyle(fontSize: 15, color: Colors.grey),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "20",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Friends",
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "120",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Following",
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "100",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Followers",
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                  margin: const EdgeInsets.only(right: 40),
                  decoration: const BoxDecoration(
                      color: Color(0xFF0f3e57),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: ListTile(
                    leading: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 25,
                    ),
                    title: const Text(
                      'Profile',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.profilePage);
                      // ...
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.upgrade_rounded,
                    size: 25,
                    color: Color(0xFFf55586),
                  ),
                  title: const Text(
                    'Upgrade',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFf55586)),
                  ),
                  onTap: () {
                    // ...
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.description_outlined,
                    size: 25,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Read',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onTap: () {
                    blogsController.filterBlogsByPostType(postType: 'text');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.videocam,
                    size: 25,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Watch',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onTap: () {
                    blogsController.filterBlogsByPostType(postType: 'video');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.headphones,
                    size: 25,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Listen',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onTap: () {
                    blogsController.filterBlogsByPostType(postType: 'audio');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.new_label_rounded,
                    size: 25,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'New',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onTap: () {
                    // ...
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 110,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => {_globalkey.currentState!.openDrawer()},
                  child: Obx(
                    () => Container(
                      height: 40,
                      width: 40,
                      margin: EdgeInsets.only(left: 40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green,
                        image: DecorationImage(
                          image: NetworkImage(
                              profileController.authenticatedUser.value.image ??
                                  ""),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 80,
                ),
                Image.asset("assets/images/logo.png"),
              ],
            ),
          ),

          // top navigation bar

          SizedBox(
            height: 30,
          ),
          Container(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: blogsController.categories.length,
              itemBuilder: (context, index) {
                String category = blogsController.categories[index];

                return GestureDetector(
                  onTap: () => blogsController.filterBlogsByRecommender(
                      category: category),
                  child: Obx(
                    () => Container(
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 8, bottom: 8),
                      decoration: BoxDecoration(
                          color: blogsController.recommender.value ==
                                  blogsController.recommenderMaps[category]
                              ? Color(0xFF46b4b5)
                              : Color(0xFF0f567c),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: Text(
                          category,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Obx(() {
            return blogsController.isLoading.value == true
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                        itemCount: blogsController.filteredBlogs.length,
                        itemBuilder: (ctx, index) {
                          final thumbnailUrl = blogsController
                              .filteredBlogs[index].thumbnailImage;

                          final isDefaultThumbnail =
                              thumbnailUrl == "default.jpg";
                          return GestureDetector(
                              onTap: () {
                                Get.to(DetailsPage(
                                    details:
                                    blogsController.filteredBlogs[index]));
                              },
                              child: Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 10),
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: isDefaultThumbnail
                                    ? Color(0xFF103e56)
                                    : null,
                              ),
                              child: Stack(
                                children: [
                                  if (!isDefaultThumbnail)
                                    Positioned.fill(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Image.network(
                                              thumbnailUrl!,
                                              fit: BoxFit.cover,
                                            ),
                                            BackdropFilter(
                                              filter: ImageFilter.blur(
                                                  sigmaX: 1, sigmaY: 1),
                                              child: Container(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 40,
                                            margin: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.green,
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    blogsController
                                                            .filteredBlogs[
                                                                index]
                                                            .authorAvatar! +
                                                        " "),
                                              ),
                                            ),
                                          ),

                                          Container(
                                            margin: EdgeInsets.only(right: 3),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .5,
                                              child: Text(
                                                blogsController
                                                        .filteredBlogs[index]
                                                        .authorDisplayName! +
                                                    " " +
                                                    blogsController
                                                        .filteredBlogs[index]
                                                        .publishedAt!,
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle: FontStyle.normal,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),

                                          // Container(
                                          //   margin: EdgeInsets.only(left: 3),
                                          //   child: Text(
                                          //     blogsController
                                          //         .filteredBlogs[index].publishedAt!,
                                          //     style: const TextStyle(
                                          //         fontSize: 10,
                                          //         fontWeight: FontWeight.w300,
                                          //         color: Colors.white),
                                          //   ),
                                          // ),
                                          // Container(
                                          //   margin: EdgeInsets.only(left: 3),
                                          //   child: blogsController
                                          //               .filteredBlogs[index].MPXR !=
                                          //           " "
                                          //       ? const Text("")
                                          //       : Row(
                                          //           children: [
                                          //             const Text(
                                          //               "| ",
                                          //               style: TextStyle(
                                          //                   fontSize: 12,
                                          //                   fontStyle:
                                          //                       FontStyle.normal,
                                          //                   color: Colors.white),
                                          //             ),
                                          //             Text(
                                          //               blogsController
                                          //                   .filteredBlogs[index]
                                          //                   .MPXR!,
                                          //               style: const TextStyle(
                                          //                   fontSize: 12,
                                          //                   fontWeight:
                                          //                       FontWeight.bold,
                                          //                   color: Colors.white),
                                          //             )
                                          //           ],
                                          //         ),
                                          // ),
                                          Container(
                                            height: 60,
                                            width: 35,
                                            margin: EdgeInsets.only(
                                                left: 10, top: 0),
                                            decoration: const BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(5),
                                                  bottomRight:
                                                      Radius.circular(5),
                                                )),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 10),
                                                  child: blogsController
                                                              .filteredBlogs[
                                                                  index]
                                                              .postTypeFormat ==
                                                          "text"
                                                      ? const Icon(
                                                          Icons
                                                              .description_outlined,
                                                          color:
                                                              Color(0xFF8aa7da),
                                                          size: 20,
                                                        )
                                                      : blogsController
                                                                  .filteredBlogs[
                                                                      index]
                                                                  .postTypeFormat ==
                                                              "video"
                                                          ? const Icon(
                                                              Icons.videocam,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      185,
                                                                      127,
                                                                      127),
                                                              size: 20,
                                                            )
                                                          : const Icon(
                                                              Icons.headphones,
                                                              color:
                                                                  Colors.green,
                                                              size: 20,
                                                            ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, top: 10),
                                        child: Text(
                                          blogsController
                                              .filteredBlogs[index].postTitle!,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF6eded0)),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, top: 10, right: 20),
                                        child: Text(
                                          blogsController
                                              .filteredBlogs[index].overview!,
                                          maxLines: 3,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                      const Spacer(),
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Text(
                                              blogsController
                                                  .filteredBlogs[index]
                                                  .minToRead!,
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Row(
                                              children: [
                                                Text(
                                                  blogsController
                                                      .filteredBlogs[index]
                                                      .likes
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.white),
                                                ),
                                                const SizedBox(
                                                  width: 2,
                                                ),
                                                const Text(
                                                  "Likes",
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  );
          })
        ],
      ),
    );
  }
}
