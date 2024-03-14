import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mindplex/features/authentication/controllers/auth_controller.dart';

import 'package:mindplex/features/drawer/view/widgets/drawer_widget.dart';
import 'package:mindplex/features/search/view/screens/search_result_page.dart';
import 'package:mindplex/features/search/view/widgets/search_bar_widget.dart';
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

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  SearchPageController searchController = Get.put(SearchPageController());
  ProfileController profileController = Get.find();
  PageNavigationController pageNavigationController = Get.find();
  AuthController authController = Get.find();

  TextEditingController searchTextEditingController = TextEditingController();

  late TabController _tabController;
  final apiService = ApiService().obs;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    searchController.isSearchResultPage.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => WillPopScope(
          onWillPop: () async {
            if (searchController.isSearchResultPage.value) {
              searchController.isSearchResultPage.value = false;
            } else {
              pageNavigationController.navigatePage(0);
            }
            return false;
          },
          child: Scaffold(
            backgroundColor: Color(0xFF0c2b46),
            body: Column(
              children: [
                Container(
                  height:
                      (searchController.isSearchResultPage.value ? 165 : 120),
                  // height: MediaQuery.of(context).size.height *
                  //     (searchController.isSearchResultPage.value ? 0.25 : 0.19),
                  child: Material(
                    color: Color(0xFF0c2b46),
                    elevation: 10,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 45,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 25.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(width: 20),
                                TopUserProfileIcon(
                                    radius: 25,
                                    profileController: profileController,
                                    authController: authController),
                                SizedBox(width: 30),
                                SearchBarWidget(
                                    searchTextEditingController:
                                        searchTextEditingController,
                                    searchController: searchController),
                                SizedBox(width: 20),
                                InkWell(
                                  child: Icon(
                                    Icons.settings,
                                    size: 38,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    if (authController.isGuestUser.value) {
                                      authController.guestReminder(context);
                                    } else {
                                      Get.toNamed(AppRoutes.settingsPage);
                                    }
                                  },
                                ),
                                SizedBox(width: 30),
                              ],
                            ),
                          ),
                        ),
                        if (searchController.isSearchResultPage.value)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
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
                      ],
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height *
                      (searchController.isSearchResultPage.value
                          ? 0.73
                          : 0.8099),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      !searchController.isSearchResultPage.value
                          ? Container(
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
                                  searchController.isIntialLoading.value
                                      ? Container(
                                          height: 320,
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                      : Column(children: [
                                          for (int i = 0;
                                              i <
                                                  (searchController
                                                          .showAllCategories
                                                          .value
                                                      ? searchController
                                                          .categories.length
                                                      : 5);
                                              i++)
                                            categoryContainer(
                                                category: searchController
                                                    .categories[i],
                                                index: i,
                                                searchTextEditingController:
                                                    searchTextEditingController)
                                        ]),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        searchController
                                                .showAllCategories.value =
                                            !searchController.showAllCategories
                                                .value; // Toggle the flag to show all categories
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(18),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            searchController
                                                    .showAllCategories.value
                                                ? "Show Less"
                                                : "Show More",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.blue,
                                                fontSize: 18),
                                          ),
                                          InkWell(
                                            child: Icon(
                                              searchController
                                                      .showAllCategories.value
                                                  ? Icons
                                                      .keyboard_arrow_up_sharp
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
                                    padding: const EdgeInsets.only(
                                        left: 18.0, top: 8),
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
                                  searchController.isIntialLoading.value
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : Obx(
                                          () => searchController
                                                      .isLoadingMore.value ==
                                                  false
                                              ? SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: IntrinsicHeight(
                                                    child: Row(
                                                      children: [
                                                        for (int i = 0;
                                                            i <
                                                                searchController
                                                                    .popularBlogs
                                                                    .length;
                                                            i++)
                                                          ArticleCard(
                                                              searchController:
                                                                  searchController,
                                                              index: i)
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                        ),
                                ],
                              ),
                            )
                          : SearchResultPage(
                              tabController: _tabController,
                              searchController: searchController),
                      SizedBox(
                        height:
                            searchController.isSearchResultPage.value ? 0 : 80,
                      )
                    ]),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
