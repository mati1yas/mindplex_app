import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:mindplex_app/blogs/blogs_controller.dart';
import 'package:mindplex_app/blogs/screens/blog_detail_page.dart';
import 'package:mindplex_app/mindplex_profile/about/about_mindplex.dart';
import 'package:mindplex_app/mindplex_profile/moderators/moderators_page.dart';
import 'package:mindplex_app/utils/colors.dart';
import 'package:shimmer_effect/shimmer_effect.dart';
import 'package:mindplex_app/blogs/widgets/blog_card.dart';

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
  bool isIntialLoading = true;
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
                                        profileController
                                            .authenticatedUser.value.friends
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        " Friends",
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
                                        profileController
                                            .authenticatedUser.value.followings
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        " Following",
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
                                        profileController
                                            .authenticatedUser.value.followers
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        " Followers",
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
                    'News',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onTap: () {
                    // ...
                  },
                ),
                ListTile(
                  leading: const Icon(
                    FontAwesome.cube,
                    size: 25,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Topics',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onTap: () {
                    // ...
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.help_outline,
                    size: 25,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'FAQ',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(
                    Icons.people_alt_sharp,
                    size: 25,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Moderators',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.to(() => ModeratorsPage());
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.people_alt_sharp,
                    size: 25,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'About Us',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.to(() => AboutMindPlex());
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "© 2023 MindPlex. All rights reserved",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      child: Icon(
                        Icons.settings,
                        size: 32,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Get.toNamed(AppRoutes.settingsPage);
                      },
                    ),
                    SizedBox(
                      width: 15,
                    )
                  ],
                ),
                SizedBox(
                  height: 60,
                )
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
                Obx(() => Text(
                    blogsController.postFormatMaps[
                            blogsController.post_format.value] ??
                        "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white))),
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
                  onTap: () {
                    isIntialLoading = true;
                    blogsController.filterBlogsByRecommender(
                        category: category);
                  },
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
            return blogsController.isLoading.value == true && isIntialLoading
                ? Expanded(
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (ctx, inx) => const BlogSkeleton(),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                        controller: blogsController.scrollController,
                        itemCount: blogsController.filteredBlogs.length + 1,
                        itemBuilder: (ctx, index) {
                          if (index < blogsController.filteredBlogs.length) {
                            final thumbnailUrl = blogsController
                                .filteredBlogs[index].thumbnailImage;
                            isIntialLoading = false;
                            final isDefaultThumbnail =
                                thumbnailUrl == "default.jpg";
                            return GestureDetector(
                                onTap: () {
                                  Get.to(DetailsPage(
                                      index: index,
                                      details: blogsController
                                          .filteredBlogs[index]));
                                },
                                child: BlogCard(
                                    blogsController: blogsController,
                                    index: index));
                          } else {
                            print("executing else statement");
                            if (index == blogsController.filteredBlogs.length &&
                                !blogsController.reachedEndOfList) {
                              // Display CircularProgressIndicator under the last card
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return Container(); // Return an empty container otherwise
                            }
                          }
                        }),
                  );
          })
        ],
      ),
    );
  }
}

class SkeletonElement extends StatelessWidget {
  const SkeletonElement({
    super.key,
    required this.isMarginForAll,
    required this.dimensions,
    required this.colors,
  });

  final bool isMarginForAll;
  final Map<String, double> dimensions;
  final Map<String, Color> colors;

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      baseColor: Color(0xFF6eded0).withOpacity(.3),
      highlightColor: Color(0xFF6eded0),
      child: Container(
        margin: isMarginForAll
            ? EdgeInsets.all(dimensions['margin_all']!)
            : EdgeInsets.fromLTRB(
                dimensions['margin_left'] ?? 0,
                dimensions['margin_top'] ?? 0,
                dimensions['margin_right'] ?? 0,
                dimensions['margin_bottom'] ?? 0,
              ),
        width: dimensions['width'],
        height: dimensions['height'],
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(dimensions['radius'] ?? 0),
          color: Color(0xFF6eded0).withOpacity(.3),
        ),
      ),
    );
  }
}

class BlogSkeleton extends StatelessWidget {
  const BlogSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: blogContainerColor.withAlpha(100),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SkeletonElement(
                    isMarginForAll: true,
                    dimensions: {
                      'height': 40,
                      'width': 40,
                      'margin_all': 10,
                      'radius': 20,
                    },
                    colors: {
                      'base': Color(0xFF103e56),
                      'highlight': Color.fromARGB(255, 28, 105, 146),
                    },
                  ),
                  SkeletonElement(
                    isMarginForAll: false,
                    dimensions: {
                      'width': MediaQuery.of(context).size.width * .4,
                      'height': 18,
                      'margin_left': 8,
                      'margin_right': 3,
                      'radius': 4,
                    },
                    colors: {
                      'base': shimmerEffectBase1,
                      'highlight': shimmerEffectHighlight1,
                    },
                  ),
                  ShimmerEffect(
                    baseColor: const Color.fromARGB(255, 46, 46, 46),
                    highlightColor:
                        const Color.fromARGB(255, 66, 66, 66).withAlpha(200),
                    child: Container(
                      height: 60,
                      width: 35,
                      margin: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      )),
                    ),
                  ),
                  SkeletonElement(
                    isMarginForAll: false,
                    dimensions: {
                      'height': 60,
                      'width': 35,
                      'margin_left': 10,
                    },
                    colors: {
                      'base': Colors.black.withAlpha(200),
                      'highlight': Colors.black.withAlpha(250),
                    },
                  ),
                ],
              ),
              SkeletonElement(
                isMarginForAll: true,
                dimensions: {
                  'width': MediaQuery.of(context).size.width * .8,
                  'height': 30,
                  'margin_all': 10,
                  'radius': 8,
                },
                colors: {
                  'base': shimmerEffectBase2,
                  'highlight': shimmerEffectHighlight2,
                },
              ),
              SkeletonElement(
                isMarginForAll: false,
                dimensions: {
                  'width': MediaQuery.of(context).size.width * .8,
                  'height': 40,
                  'margin_left': 10,
                  'margin_right': 10,
                  'radius': 8,
                },
                colors: {
                  'base': shimmerEffectBase2,
                  'highlight': shimmerEffectHighlight2,
                },
              ),
              const Spacer(),
              Row(
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  SkeletonElement(
                    isMarginForAll: false,
                    dimensions: {
                      'width': 40,
                      'height': 15,
                      'radius': 4,
                      'margin_bottom': 5
                    },
                    colors: {
                      'base': shimmerEffectBase1,
                      'highlight': shimmerEffectHighlight1,
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SkeletonElement(
                    isMarginForAll: false,
                    dimensions: {
                      'width': 40,
                      'height': 15,
                      'radius': 4,
                      'margin_bottom': 5
                    },
                    colors: {
                      'base': shimmerEffectBase1,
                      'highlight': shimmerEffectHighlight1,
                    },
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
