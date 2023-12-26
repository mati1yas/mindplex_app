import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:mindplex/auth/auth_controller/auth_controller.dart';
import 'package:mindplex/blogs/blogs_controller.dart';
import 'package:mindplex/blogs/screens/blog_detail_page.dart';
import 'package:mindplex/blogs/widgets/blog_shimmer.dart';
import 'package:mindplex/blogs/widgets/post_topic_widget.dart';
import 'package:mindplex/mindplex_profile/about/about_mindplex.dart';
import 'package:mindplex/mindplex_profile/moderators/moderators_page.dart';
import 'package:mindplex/utils/colors.dart';
import 'package:shimmer_effect/shimmer_effect.dart';
import 'package:mindplex/blogs/widgets/blog_card.dart';

import '../drawer/top_user_profile_icon.dart';
import '../profile/user_profile_controller.dart';
import '../utils/constatns.dart';
import '../routes/app_routes.dart';
import '../drawer/drawer_widget.dart';

class LandingPage extends StatefulWidget {
  LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  bool isIntialLoading = true;

  BlogsController blogsController = Get.find();

  ProfileController profileController = Get.find();

  AuthController authController = Get.find();

  late TabController _tabController;
  late TabController _tabController2;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      String category = blogsController.categories[_tabController.index];
      isIntialLoading = true;
      blogsController.filterBlogsByRecommender(category: category);
    });

    _tabController2 = TabController(length: 7, vsync: this);
    _tabController2.addListener(() {
      String category = blogsController.categories[_tabController2.index];

      isIntialLoading = true;
      blogsController.filterBlogsByRecommender(category: category);
    });
  }

  @override
  Widget build(BuildContext context) {
    profileController.getAuthenticatedUser();

    _tabController.index = 0;
    _tabController2.index = 0;

    blogsController.fetchBlogs();

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFF0c2b46),
      // key: Keys.globalkey,
      // drawer: Drawer(
      //   child: DrawerWidget(),
      // ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TopUserProfileIcon(
                      profileController: profileController,
                      authController: authController),
                  SizedBox(
                    width: width * 0.14,
                  ),
                  Obx(() => Container(
                        width: width * 0.40,
                        child: Center(
                          child: Text(
                              blogsController.post_type == 'news'
                                  ? "News"
                                  : blogsController.post_type ==
                                          'community_content'
                                      ? "Community"
                                      : blogsController.post_type == 'topics'
                                          ? "Topics"
                                          : blogsController.postFormatMaps[
                                                  blogsController
                                                      .post_format.value] ??
                                              "",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.white)),
                        ),
                      )),
                ],
              ),
            ),
          ),

          // top navigation bar

          Obx(() => blogsController.post_type == 'topics'
              ? Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    PostTopics(blogsController: blogsController),
                  ],
                )
              : SizedBox.shrink()),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              alignment: Alignment.centerLeft,
              height: 35,
              decoration: BoxDecoration(
                color: Color.fromARGB(50, 118, 118, 128),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(
                () => blogsController.post_type != 'community_content'
                    ? TabBar(
                        isScrollable: false,
                        dividerColor: Colors.grey,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: blogsController.post_format == 'text'
                                ? Color(0xFF8aa7da)
                                : blogsController.post_format == 'video'
                                    ? Color.fromARGB(239, 203, 141, 141)
                                    : blogsController.post_format == "listen"
                                        ? const Color.fromARGB(
                                            255, 131, 235, 100)
                                        : const Color.fromARGB(
                                            255, 131, 235, 100)
                            // color: const Color.fromARGB(255, 49, 153, 167),
                            ),
                        indicatorColor: Colors.green,
                        controller: _tabController,
                        unselectedLabelStyle:
                            TextStyle(fontWeight: FontWeight.w300),
                        tabs: [
                            Tab(
                              text: "All",
                            ),
                            Tab(text: "Popular"),
                            Tab(text: "Most Recent"),
                            Tab(text: "Trending"),
                          ])
                    : TabBar(
                        isScrollable: true,
                        dividerColor: Colors.grey,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: blogsController.post_format == 'text'
                                ? Color(0xFF8aa7da)
                                : blogsController.post_format == 'video'
                                    ? Color.fromARGB(239, 203, 141, 141)
                                    : blogsController.post_format == "listen"
                                        ? const Color.fromARGB(
                                            255, 131, 235, 100)
                                        : const Color.fromARGB(
                                            255, 131, 235, 100)
                            // color: const Color.fromARGB(255, 49, 153, 167),
                            ),
                        indicatorColor: Colors.green,
                        controller: _tabController2,
                        unselectedLabelStyle:
                            TextStyle(fontWeight: FontWeight.w300),
                        tabs: [
                            Tab(
                              text: "All",
                            ),
                            Tab(text: "Popular"),
                            Tab(text: "Most Recent"),
                            Tab(text: "Trending"),
                            Tab(text: "Article"),
                            Tab(text: "Video"),
                            Tab(text: "Podcast"),
                          ]),
              ),
            ),
          ),

          Obx(() {
            return (blogsController.isLoadingMore.value == true &&
                        isIntialLoading) ||
                    blogsController.newPostTypeLoading.value
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
                            return BlogCard(
                                blogsController: blogsController, index: index);
                          } else {
                            print("executing else statement");
                            if (index == blogsController.filteredBlogs.length &&
                                !blogsController.reachedEndOfList) {
                              // Display CircularProgressIndicator under the last card
                              return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 5,
                                itemBuilder: (ctx, inx) => const BlogSkeleton(),
                              );
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
