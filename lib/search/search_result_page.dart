import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:mindplex/utils/colors.dart';

import '../blogs/blogs_controller.dart';
import '../blogs/screens/blog_detail_page.dart';
import '../blogs/widgets/blog_card.dart';
import '../blogs/widgets/blog_shimmer.dart';
import '../mindplex_profile/about/about_mindplex.dart';
import '../mindplex_profile/moderators/moderators_page.dart';
import '../models/search_response.dart';
import '../models/user_profile.dart';
import '../profile/user_profile_controller.dart';
import '../routes/app_routes.dart';
import '../services/api_services.dart';
import '../utils/constatns.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage>
    with SingleTickerProviderStateMixin {
  BlogsController blogsController = Get.put(BlogsController());

  GlobalKey<ScaffoldState> _globalkey = GlobalKey<ScaffoldState>();

  ProfileController profileController = Get.put(ProfileController());
  TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  final apiService = ApiService().obs;
  bool isLoading = true;
  Map<String, String?> params = Get.parameters;
  List<UserProfile> users = [];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _searchController.text = params['query']!;
    fetchSearchResults();
    super.initState();
    print("aaaaaaaaaaaaagh");
  }

  void fetchSearchResults() async {
    setState(() {
      isLoading = true;
    });
    blogsController.fetchSearchResults(_searchController.text);
    final res =
        await apiService.value.fetchSearchResponse(_searchController.text, 1);
    users = res.users!;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0c2b46),
      key: _globalkey,
      body: Column(children: [
        Container(
          height: 110,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => {Keys.globalkey.currentState!.openDrawer()},
                child: Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.only(left: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFF0c2b46),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          profileController.authenticatedUser.value.image ??
                              ""),
                    ),
                  ),
                ),
              ),
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _searchController,
                          textAlign: TextAlign.end,
                          onFieldSubmitted: (String value) {
                            fetchSearchResults();
                          },
                          keyboardType: TextInputType.text,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.black,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            contentPadding: const EdgeInsets.all(10),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
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
                return blogsController.isLoadingMore.value == true && isLoading
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
                              if (index <
                                  blogsController.searchedBlogs.length) {
                                return SearchBlogCard(
                                    blogsController: blogsController,
                                    index: index);
                              } else {
                                print("executing else statement");
                                if (index ==
                                        blogsController.searchedBlogs.length &&
                                    !blogsController.reachedEndOfListSearch) {
                                  // Display CircularProgressIndicator under the last card
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  return Container(
                                    child: Center(
                                      child: Text(
                                        "No Content",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ); // Return an empty container otherwise
                                }
                              }
                            }),
                      );
              }),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      child: users.length == 0
                          ? Center(
                              child: Text(
                                "No users match your search query",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (ctx, index) {
                                return UserCard(user: users[index]);
                              }),
                    )
            ],
          ),
        ),
      ]),
    );
  }

  Widget _container(String mainContent, String posts) {
    return Container(
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
                    mainContent,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    posts + "k posts",
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
    );
  }
}

class SearchBlogCard extends StatelessWidget {
  const SearchBlogCard({
    super.key,
    required this.blogsController,
    required this.index,
  });

  final BlogsController blogsController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    //  will be modified in detail .

                    Get.toNamed(AppRoutes.profilePage, parameters: {
                      "me": "notme",
                      "username":
                          blogsController.searchedBlogs[index].authorUsername ??
                              ""
                    });
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        blogsController.searchedBlogs[index].authorAvatar ??
                            ""),
                    radius: 20,
                    backgroundColor: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(DetailsPage(
                          index: index,
                          details: blogsController.searchedBlogs[index]));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              blogsController
                                      .searchedBlogs[index].authorDisplayName ??
                                  "",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              blogsController
                                      .searchedBlogs[index].authorUsername ??
                                  "",
                              style: TextStyle(
                                color: Color.fromARGB(255, 123, 122, 122),
                              ),
                            ),
                            Text(
                              blogsController
                                      .searchedBlogs[index].publishedAt ??
                                  "",
                              style: TextStyle(
                                color: Color.fromARGB(255, 123, 122, 122),
                              ),
                            ),
                            Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                            )
                          ],
                        ),
                        Text(
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            blogsController.searchedBlogs[index].postTitle ??
                                ""),
                        Text(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            blogsController.searchedBlogs[index].overview ??
                                ""),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          blogsController.searchedBlogs[index].minToRead ?? "",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(blogsController
                                              .searchedBlogs[index]
                                              .thumbnailImage ??
                                          ""))),
                              height: 170,
                              width: 400,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 1, right: 8.0),
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
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          child: blogsController
                                                      .searchedBlogs[index]
                                                      .postTypeFormat ==
                                                  "text"
                                              ? const Icon(
                                                  Icons.description_outlined,
                                                  color: Color(0xFF8aa7da),
                                                  size: 20,
                                                )
                                              : blogsController
                                                          .searchedBlogs[index]
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
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    //  like logic will be here
                                  },
                                  child: Icon(
                                    color: Colors.white,
                                    Icons.thumb_up_off_alt_outlined,
                                  ),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  blogsController.searchedBlogs[index].likes
                                          .toString() +
                                      " Likes",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    //  share logic will be here
                                  },
                                  child: Icon(
                                    color: Colors.white,
                                    Icons.share_outlined,
                                  ),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  color: Colors.white,
                                  Icons.mode_comment_outlined,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  blogsController.searchedBlogs[index].comments
                                          .toString() +
                                      " comments",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    //  dislike logic will be here
                                  },
                                  child: Icon(
                                    color: Colors.white,
                                    Icons.thumb_down_off_alt_outlined,
                                  ),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  "Dislike",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Divider(
              color: Colors.white,
              thickness: 1,
            )
          ],
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user});
  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //  will be modified in detail .

        Get.toNamed(AppRoutes.profilePage,
            parameters: {"me": "notme", "username": user.username ?? ""});
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    foregroundImage: NetworkImage(user.avatarUrl ?? ""),
                    radius: 20,
                    child: const Material(
                      color: Color.fromARGB(0, 231, 6, 6), //
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.firstName! + " " + user.lastName!,
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                        Text(
                          user.username!,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              key: UniqueKey(),
              width: 60,
              height: 30,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 49, 153, 167),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: Text("follow",
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
