import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/blogs_controller.dart';

class DefaultTabBar extends StatelessWidget {
  const DefaultTabBar({
    super.key,
    required this.blogsController,
    required TabController tabController,
  }) : _tabController = tabController;

  final BlogsController blogsController;
  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TabBar(
          isScrollable: true,
          dividerColor: Colors.grey,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
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
    );
  }
}
