import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/authentication/controllers/auth_controller.dart';
import 'package:mindplex/features/blogs/controllers/blogs_controller.dart';
import 'package:mindplex/features/blogs/view/widgets/social_feed_card.dart';

import '../../../drawer/view/widgets/top_user_profile_icon.dart';
import '../widgets/blog_card.dart';
import '../widgets/blog_shimmer.dart';
import '../widgets/community_content_tabbar.dart';
import '../widgets/default_tabbar.dart';
import '../widgets/post_topic_widget.dart';
import '../../../user_profile_displays/controllers/user_profile_controller.dart';
import '../widgets/social_feed_post_form_widget.dart';

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
            child: Column(
              children: [
                Container(
                  height: height * 0.15,
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
                              child: Text(blogsController.landingPageHeader(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Colors.white)),
                            ),
                          )),
                    ],
                  ),
                ),

                // section for making a post to social feed .
                Obx(() => blogsController.post_type == 'social'
                    ? SocialFeedForm()
                    : SizedBox.shrink()),
              ],
            ),
          ),

          // top navigation bar

          // this section shows list of topics to be selected by a user
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

          //  for social feed we dont have tab bar for selecting post format
          Obx(
            () => blogsController.post_type != 'social'
                ? Padding(
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
                            ? DefaultTabBar(
                                blogsController: blogsController,
                                tabController: _tabController)
                            : CommunityContentTabBar(
                                blogsController: blogsController,
                                tabController2: _tabController2),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ),

          // section for displaying user

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
                            isIntialLoading = false;
                            return blogsController.post_type != 'social'
                                ? BlogCard(
                                    blogsController: blogsController,
                                    index: index)
                                : SocialFeedCard(
                                    blogsController: blogsController,
                                    index: index);
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
