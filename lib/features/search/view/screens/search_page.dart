import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mindplex/features/authentication/controllers/auth_controller.dart';

import 'package:mindplex/features/drawer/view/widgets/drawer_widget.dart';
import 'package:mindplex/features/search/view/widgets/search_blog_card_widget.dart';
import 'package:mindplex/features/search/view/widgets/category_container_widget.dart';
import 'package:mindplex/utils/colors.dart';

import '../../../bottom_navigation_bar/controllers/bottom_page_navigation_controller.dart';
import '../../controllers/search_controller.dart';

import '../../../blogs/view/screens/blog_detail_page.dart';

import '../../../blogs/view/widgets/blog_shimmer.dart';
import '../../../drawer/view/widgets/top_user_profile_icon.dart';
import '../../models/search_response.dart';
import '../../../user_profile_settings/models/user_profile.dart';
import '../../../user_profile_displays/controllers/user_profile_controller.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/constatns.dart';
import '../../../../services/api_services.dart';
import '../widgets/article_card_widget.dart';
import '../widgets/user_card_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {

  SearchPageController searchController = Get.put(SearchPageController());
  ProfileController profileController = Get.find();
  PageNavigationController pageNavigationController = Get.find();
  AuthController authController = Get.find();

  TextEditingController _searchController = TextEditingController();

  late TabController _tabController;
  final apiService = ApiService().obs;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => WillPopScope(
      onWillPop: () async {
        if(searchController.isSearchResultPage.value){
          searchController.isSearchResultPage.value = false;
        }
        else{
          pageNavigationController.navigatePage(0);
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xFF0c2b46),
        body: searchController.isIntialLoading.value
            ? Center(
          child: CircularProgressIndicator(),
        )
            : Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                height: 110,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TopUserProfileIcon(
                        profileController: profileController,
                        authController: authController),
                    SizedBox(width: 30),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode
                                    .onUserInteraction,
                                controller: _searchController,
                                textAlign: TextAlign.end,
                                onFieldSubmitted: (String value) {
                                    searchController.isSearchResultPage.value = true;
                                    searchController.fetchSearchResults(_searchController.text);
                                },
                                keyboardType: TextInputType.text,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey),
                                textAlignVertical:
                                TextAlignVertical.center,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.black,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                    borderRadius:
                                    BorderRadius.circular(30.0),
                                  ),
                                  contentPadding:
                                  const EdgeInsets.all(10),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                    borderRadius:
                                    BorderRadius.circular(30.0),
                                  ),
                                  border: InputBorder.none,
                                  hintText: 'Search',
                                  hintStyle:
                                  TextStyle(color: Colors.grey),
                                ),
                                onChanged: (value) {},
                                validator: (value) {},
                              ),
                            ),
                            Flexible(
                                flex: 1,
                                fit: FlexFit.loose,
                                child: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    InkWell(
                      child: Icon(
                        Icons.settings,
                        size: 38,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Get.toNamed(AppRoutes.settingsPage);
                      },
                    ),
                    SizedBox(width: 30),
                  ],
                ),
              ),
              SizedBox(height: 30,),
              !searchController.isSearchResultPage.value ?
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Trends for you",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20),
                          )),
                    ),
                    Column(children: [
                      for (int i = 0;
                      i <
                          (searchController.showAllCategories.value
                              ? searchController.categories.length
                              : 5);
                      i++)
                        GestureDetector(
                            onTap: () {
                              searchController.isSearchResultPage.value = true;
                              _searchController.text = searchController.categories[i].slug;
                              searchController.fetchSearchResults(searchController.categories[i].slug);
                            },
                            child: categoryContainer(searchController.categories[i]))
                    ]),
                    InkWell(
                      onTap: () {
                        setState(() {
                          searchController.showAllCategories.value = !searchController.showAllCategories.value; // Toggle the flag to show all categories
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(18),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              searchController.showAllCategories.value
                                  ? "Show Less"
                                  : "Show More",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                  fontSize: 18),
                            ),
                            InkWell(
                              child: Icon(
                                searchController.showAllCategories.value
                                    ? Icons.keyboard_arrow_up_sharp
                                    : Icons.arrow_forward_ios,
                                color: Colors.blue,
                                size: 30,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 2.0,
                      color: Colors.white,
                      indent: 18,
                      endIndent: 18,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 18.0, top: 8),
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Articles for you",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 8),
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Check out these popular and trending articles for you",
                            style: TextStyle(
                                fontWeight: FontWeight.w200,
                                color: Colors.white,
                                fontSize: 15),
                          )),
                    ),
                    Obx(
                          () => searchController.isLoadingMore.value == false
                          ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              for (int i = 0;
                              i <
                                  searchController
                                      .popularBlogs.length;
                              i++)
                                ArticleCard(
                                    searchController: searchController,
                                    index: i)
                            ],
                          ),
                        ),
                      )
                          : Container(),
                    ),
                  ],
                ),
              ):
              Container(
                height: MediaQuery.of(context).size.height - 140,
                child: Column(children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(50, 118, 118, 128),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TabBar(
                        dividerColor: Colors.transparent,
                        controller: _tabController,
                        isScrollable: false,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(255, 49, 153, 167)),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white,
                        tabs: [
                          Tab(
                            text: 'Content',
                          ),
                          Tab(
                            text: 'Users',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Obx(() {
                          return searchController.isLoading.value == true
                              ? Expanded(
                            child: ListView.builder(
                              itemCount: 5,
                              itemBuilder: (ctx, inx) =>
                              const BlogSkeleton(),
                            ),
                          )
                              : Expanded(
                            child: ListView.builder(
                                controller: searchController.searchScrollController,
                                itemCount: searchController.searchedBlogs.length + 1,
                                itemBuilder: (ctx, index) {
                                  if (index < searchController.searchedBlogs.length) {
                                    return SearchBlogCard(searchController: searchController, index: index);
                                  } else {
                                    print("executing else statement");
                                    if (index == searchController.searchedBlogs.length && !searchController.reachedEndOfListSearch.value) {
                                      return Container(
                                          height: 250,
                                          child: BlogSkeleton());
                                    } else {
                                      return Container(
                                        child: Center(
                                          child: Text(
                                            "No Content",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                        ),
                                      ); // Return an empty container otherwise
                                    }
                                  }
                                }),
                          );
                        }),
                        Obx(() {
                          return searchController.isUserLoading.value == true
                              ? Expanded(child: Center(child: CircularProgressIndicator(),))
                              : Expanded(
                            child: ListView.builder(
                                controller: searchController.searchUserScrollController,
                                itemCount: searchController.getSearchedUsers.length +
                                    1,
                                itemBuilder: (ctx, index) {
                                  if (index <
                                      searchController
                                          .getSearchedUsers.length) {
                                    return UserCard(
                                        user: searchController,
                                        index: index);
                                  } else {
                                    print("executing else statement");
                                    if (index == searchController.getSearchedUsers.length && !searchController.reachedEndOfListSearchUser.value) {
                                      // Display CircularProgressIndicator under the last card
                                      return Center(
                                          child:
                                          CircularProgressIndicator());
                                    } else {
                                      return Container(
                                        child: Center(
                                          child: Text(
                                            "No Content",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                        ),
                                      ); // Return an empty container otherwise
                                    }
                                  }
                                }),
                          );
                        }),
                      ],
                    ),
                  ),
                ],),
              ),
              SizedBox(
                height: searchController.isSearchResultPage.value?0:80,
              )
            ]),
          ),
        ),
      ),
    ));
  }
}
