import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mindplex/auth/auth_controller/auth_controller.dart';

import 'package:mindplex/drawer/drawer_widget.dart';
import 'package:mindplex/search/search_result_page.dart';
import 'package:mindplex/utils/colors.dart';

import '../blogs/blogs_controller.dart';

import '../blogs/screens/blog_detail_page.dart';
import '../blogs/widgets/blog_shimmer.dart';
import '../drawer/top_user_profile_icon.dart';
import '../models/search_response.dart';
import '../models/user_profile.dart';
import '../profile/user_profile_controller.dart';
import '../routes/app_routes.dart';
import '../utils/constatns.dart';
import '../services/api_services.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin{
  BlogsController blogsController = Get.put(BlogsController());

  ProfileController profileController = Get.put(ProfileController());
  TextEditingController _searchController = TextEditingController();
  AuthController authController = Get.find();
  late TabController _tabController;
  final apiService = ApiService().obs;
  bool isIntialLoading = true;
  bool showAllCategories = false;
  List<Category> categories = [];
  List<UserProfile> users = [];
  bool isLoading = true;
  bool isSearchResultPage = false;

  void fetchCategories() async {
    final res = await apiService.value.fetchSearchLanding();
    print(res.categories?[0].posts);
    categories = res.categories!;
    setState(() {
      isIntialLoading = false;
    });
  }
  void fetchSearchResults() async{
    setState(() {
      isLoading = true;
    });
    blogsController.fetchSearchResults(_searchController.text);
    final res = await apiService.value.fetchSearchResponse(_searchController.text,1);
    users = res.users!;
    setState(() {
      isLoading = false;
    });
  }
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    fetchCategories();
    blogsController.fetchPopularBlogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !isSearchResultPage?Scaffold(
      backgroundColor: Color(0xFF0c2b46),
      body: isIntialLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          :Container(
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
                            decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(30)),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    controller: _searchController,
                                    textAlign: TextAlign.end,
                                    onFieldSubmitted: (String value){
                                      setState(() {
                                        isSearchResultPage = true;
                                      });
                                      fetchSearchResults();
                                    },
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.black,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.transparent),
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                      contentPadding: const EdgeInsets.all(10),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.transparent),
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                      border: InputBorder.none,
                                      hintText: 'Search',
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                    onChanged: (value) {},
                                    validator: (value) {},
                                  ),
                                ),
                                Flexible(flex:1,fit:FlexFit.loose,child: Icon(Icons.search,color: Colors.grey,))
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
                  SizedBox(
                    height:  !isSearchResultPage?30:15,
                  ),
                   Column(
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
                          i < (showAllCategories ? categories.length : 5);
                          i++)
                            _container(categories[i])
                        ]),
                        InkWell(
                          onTap: () {
                            setState(() {
                              showAllCategories =
                              !showAllCategories; // Toggle the flag to show all categories
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  showAllCategories ? "Show Less" : "Show More",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue,
                                      fontSize: 18),
                                ),
                                InkWell(
                                  child: Icon(
                                    showAllCategories
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
                          padding: const EdgeInsets.only(left: 18.0, top: 8),
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
                              () => blogsController.isLoading.value == false
                              ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  for (int i = 0;
                                  i < blogsController.popularBlogs.length;
                                  i++)
                                    ArticleCard(
                                        blogsController: blogsController,
                                        index: i)
                                ],
                              ),
                            ),
                          )
                              : Container(),
                        ),
                      ],
                  ),
                  SizedBox(
                    height: 80,
                  )
                ]),
              ),
            ),
    ):
    WillPopScope(
      onWillPop: () async{
        if(isSearchResultPage){
          setState(() {
            isSearchResultPage = false;
          });
        }
        else{
          Navigator.pop(context);
        }
        return true;
      },
      child: Scaffold(
          backgroundColor: Color(0xFF0c2b46),
          body:Column(
              children: [
                Container(
                  height: 110,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () =>
                        {Keys.globalkey.currentState!.openDrawer()},
                        child: Container(
                          height: 40,
                          width: 40,
                          margin: EdgeInsets.only(left: 40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xFF0c2b46),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(profileController
                                  .authenticatedUser.value.image ??
                                  ""),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 30),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  controller: _searchController,
                                  textAlign: TextAlign.end,
                                  onFieldSubmitted: (String value){
                                    fetchSearchResults();
                                  },
                                  keyboardType: TextInputType.text,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.black,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    contentPadding: const EdgeInsets.all(10),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    border: InputBorder.none,
                                    hintText: 'Search',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  onChanged: (value) {},
                                  validator: (value) {},
                                ),
                              ),
                              Flexible(flex:1,fit:FlexFit.loose,child: Icon(Icons.search,color: Colors.grey,))
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
                SizedBox(height:10),
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
                        return blogsController.isLoading.value == true && isLoading
                            ? Expanded(
                          child: ListView.builder(
                            itemCount: 5,
                            itemBuilder: (ctx, inx) => const BlogSkeleton(),
                          ),
                        )
                            : Expanded(
                          child: ListView.builder(
                              controller: blogsController.searchScrollController,
                              itemCount: blogsController.searchedBlogs.length + 1,
                              itemBuilder: (ctx, index) {
                                if (index < blogsController.searchedBlogs.length) {
                                  return SearchBlogCard(
                                      blogsController: blogsController, index: index);
                                } else {
                                  print("executing else statement");
                                  if (index == blogsController.searchedBlogs.length &&
                                      !blogsController.reachedEndOfListSearch) {
                                    // Display CircularProgressIndicator under the last card
                                    return Center(child: CircularProgressIndicator());
                                  } else {
                                    return Container(child: Center(child: Text("No Content",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),),); // Return an empty container otherwise
                                  }
                                }
                              }),
                        );
                      }),
                      isLoading?Center(child: CircularProgressIndicator(),):Container(
                        child: users.length == 0?Center(child: Text("No users match your search query",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),):ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (ctx, index) {
                              return UserCard(
                                  user: users[index]);
                            }),
                      )
                    ],
                  ),
                ),
              ]
          )),
    );
  }

  Widget _container(Category category) {
    return GestureDetector(
      onTap: () {
        _searchController.text = category.slug;
        setState(() {
          isSearchResultPage = true;
          fetchSearchResults();
        });
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      category.posts.toString() + "posts",
                      style: TextStyle(
                          fontWeight: FontWeight.w100,
                          color: Colors.white,
                          fontSize: 15),
                    )
                  ],
                ),
              ),
              InkWell(
                child: Icon(
                  Icons.more_horiz,
                  size: 22,
                  color: Colors.white,
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  const ArticleCard({
    super.key,
    required this.blogsController,
    required this.index,
  });

  final BlogsController blogsController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white),
          color: blogContainerColor),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.65,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(DetailsPage(
                    index: index,
                    details: blogsController.popularBlogs[index]));
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(blogsController
                                      .popularBlogs[index].thumbnailImage ??
                                  ""))),
                      height: 100,
                      width: 300,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 1, right: 8.0),
                        child: Container(
                            height: 60,
                            width: 35,
                            margin: EdgeInsets.only(left: 10, top: 0),
                            decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                )),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: blogsController.popularBlogs[index]
                                              .postTypeFormat ==
                                          "text"
                                      ? const Icon(
                                          Icons.description_outlined,
                                          color: Color(0xFF8aa7da),
                                          size: 20,
                                        )
                                      : blogsController.popularBlogs[index]
                                                  .postTypeFormat ==
                                              "video"
                                          ? const Icon(
                                              Icons.videocam,
                                              color: Color.fromARGB(
                                                  255, 185, 127, 127),
                                              size: 20,
                                            )
                                          : const Icon(
                                              Icons.headphones,
                                              color: Colors.green,
                                              size: 20,
                                            ),
                                )
                              ],
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    //  will be modified in detail .

                    Get.toNamed(AppRoutes.profilePage, parameters: {
                      "me": "notme",
                      "username":
                          blogsController.popularBlogs[index].authorUsername ??
                              ""
                    });
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        blogsController.popularBlogs[index].authorAvatar ?? ""),
                    radius: 15,
                    backgroundColor: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  blogsController.popularBlogs[index].authorDisplayName ?? "",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  blogsController.popularBlogs[index].publishedAt ?? "",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    blogsController.popularBlogs[index].postTitle ?? ""),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    blogsController.popularBlogs[index].overview ?? ""),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(
                    blogsController.popularBlogs[index].minToRead ?? "",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "19.9k views",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
