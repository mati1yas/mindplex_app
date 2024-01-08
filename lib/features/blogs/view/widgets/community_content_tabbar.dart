import 'package:flutter/material.dart';

import '../../controllers/blogs_controller.dart';

class CommunityContentTabBar extends StatelessWidget {
  const CommunityContentTabBar({
    super.key,
    required this.blogsController,
    required TabController tabController2,
  }) : _tabController2 = tabController2;

  final BlogsController blogsController;
  final TabController _tabController2;

  @override
  Widget build(BuildContext context) {
    return TabBar(
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
        controller: _tabController2,
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w300),
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
        ]);
  }
}
