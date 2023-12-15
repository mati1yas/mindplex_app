import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:mindplex/auth/auth_controller/auth_controller.dart';
import 'package:mindplex/blogs/blogs_controller.dart';
import 'package:mindplex/blogs/screens/blog_detail_page.dart';
import 'package:mindplex/blogs/widgets/blog_shimmer.dart';
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
    with SingleTickerProviderStateMixin {
  // bool isIntialLoading = true;

  BlogsController blogsController = Get.find();

  ProfileController profileController = Get.find();

  AuthController authController = Get.find();

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      String category = blogsController.categories[_tabController.index];
      // isIntialLoading = true;
      blogsController.filterBlogsByRecommender(category: category);
    });
  }

  @override
  Widget build(BuildContext context) {
    profileController.getAuthenticatedUser();

    return Scaffold(
      backgroundColor: Color(0xFF0c2b46),
      // key: Keys.globalkey,
      // drawer: Drawer(
      //   child: DrawerWidget(),
      // ),
      body: Column(
        children: [
          Container(
            height: 90,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TopUserProfileIcon(
                    profileController: profileController,
                    authController: authController),
                const SizedBox(
                  width: 80,
                ),
                Obx(() => Text(
                    blogsController.post_type != 'news'
                        ? blogsController.postFormatMaps[
                                blogsController.post_format.value] ??
                            ""
                        : "News",
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
            alignment: Alignment.center,
            width: 345,
            height: 35,
            decoration: BoxDecoration(
              color: Color.fromARGB(50, 118, 118, 128),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Obx(
              () => TabBar(
                  isScrollable: true,
                  dividerColor: Colors.grey,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: blogsController.post_format == 'text'
                          ? Color(0xFF8aa7da)
                          : blogsController.post_format == 'video'
                              ? Color.fromARGB(239, 203, 141, 141)
                              : blogsController.post_format == "listen"
                                  ? const Color.fromARGB(255, 131, 235, 100)
                                  : const Color.fromARGB(255, 131, 235, 100)
                      // color: const Color.fromARGB(255, 49, 153, 167),
                      ),
                  indicatorColor: Colors.green,
                  controller: _tabController,
                  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w300),
                  tabs: [
                    Tab(
                      text: "All",
                    ),
                    Tab(text: "Popular"),
                    Tab(text: "Most Recent"),
                    Tab(text: "Trending"),
                  ]),
            ),
          ),

          Obx(() {
            return blogsController.isLoading.value == true
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
                            // isIntialLoading = false;
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
