import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/blogs/view/widgets/blog_shimmer.dart';
import 'package:mindplex/features/search/controllers/search_controller.dart';
import 'package:mindplex/features/search/view/widgets/search_bar_widget.dart';
import 'package:mindplex/features/search/view/widgets/search_blog_card_widget.dart';
import 'package:mindplex/features/search/view/widgets/user_card_widget.dart';
import 'package:mindplex/utils/no_internet_card_widget.dart';

class SearchResultPage extends StatelessWidget {
  const SearchResultPage({
    super.key,
    required TabController tabController,
    required this.searchController,
  }) : _tabController = tabController;

  final TabController _tabController;
  final SearchPageController searchController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 140,
      child: Column(
        children: [
          SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Obx(() => !searchController.isConnected.value
                    ? noInternetCard(() {})
                    : searchController.isLoading.value == true
                        ? ListView.builder(
                            itemCount: 5,
                            itemBuilder: (ctx, inx) => const BlogSkeleton(),
                          )
                        : ListView.builder(
                            controller: searchController.searchScrollController,
                            itemCount:
                                searchController.searchedBlogs.length + 1,
                            itemBuilder: (ctx, index) {
                              if (index <
                                  searchController.searchedBlogs.length) {
                                return SearchBlogCard(
                                    searchController: searchController,
                                    index: index);
                              } else {
                                print("executing else statement");
                                if (index ==
                                        searchController.searchedBlogs.length &&
                                    !searchController
                                        .reachedEndOfListSearch.value) {
                                  return Container(
                                      height: 300, child: BlogSkeleton());
                                } else {
                                  return Container(
                                    child: Center(
                                      child: Text(
                                        searchController.searchPage == 1
                                            ? "No Content"
                                            : "no more content",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ); // Return an empty container otherwise
                                }
                              }
                            })),
                Obx(() {
                  return searchController.isUserLoading.value == true
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          controller:
                              searchController.searchUserScrollController,
                          itemCount:
                              searchController.getSearchedUsers.length + 1,
                          itemBuilder: (ctx, index) {
                            if (index <
                                searchController.getSearchedUsers.length) {
                              return UserCard(
                                  user: searchController, index: index);
                            } else {
                              print("executing else statement");
                              if (index ==
                                      searchController
                                          .getSearchedUsers.length &&
                                  !searchController
                                      .reachedEndOfListSearchUser.value) {
                                // Display CircularProgressIndicator under the last card
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return Container(
                                  child: Center(
                                    child: Text(
                                      searchController.searchUserPage == 1
                                          ? "No users"
                                          : "no more users",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ); // Return an empty container otherwise
                              }
                            }
                          });
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
