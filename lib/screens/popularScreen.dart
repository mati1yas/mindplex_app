import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex_app/services/PopularServices.dart';
import 'dart:ui' show ImageFilter;
import '../models/popularModel.dart';
import '../routes/app_routes.dart';

class PopularScreen extends StatefulWidget {
  const PopularScreen({super.key});

  @override
  State<PopularScreen> createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen> {
  List<PopularDetails> popularList = [];
  Map<String, List<PopularDetails>> popularListGrouped = {};
  GlobalKey<ScaffoldState> _globalkey = GlobalKey<ScaffoldState>();
  bool isLoading = true;

  int currentCategoryIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
      loadPopularList();
    });
    super.initState();

    // popularList =
    //     Provider.of<PopularProvider>(context, listen: false).getAllPopularList;
  }

  /*
  Builder(builder: (ctx) {
        Scaffold.of(ctx).openDrawer();
        return Container();
      }
  */
  @override
  Widget build(BuildContext context) {
    // popularList = context.read<PopularProvider>().getAllPopularList;
    return Scaffold(
      backgroundColor: Color(0xFF0c2b46),
      key: _globalkey,
      drawer: Drawer(
        child: BackdropFilter(
          blendMode: BlendMode.srcOver,
          filter: ImageFilter.blur(
              sigmaX: 13.0, sigmaY: 13.0, tileMode: TileMode.clamp),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF062f46), Color(0xFF1d253d)],
            )),
            child: ListView(
              padding: EdgeInsets.only(top: 20, left: 20),
              children: [
                // UserAccountsDrawerHeader(
                //   accountName: Text(
                //     "Ayden Tiao",
                //     style: TextStyle(fontSize: 30),
                //   ),
                //   accountEmail: Text("@AydenTiao"),
                //   currentAccountPicture: const CircleAvatar(
                //       backgroundImage: AssetImage('assets/images/profile.PNG')),
                //   decoration: const BoxDecoration(
                //     color: Color(0xFF0b2c44),
                //   ),
                // ),
                Container(
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 50,
                          width: 50,
                          margin:
                              EdgeInsets.only(top: 40, left: 10, bottom: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.green,
                            image: DecorationImage(
                              image: AssetImage("assets/images/profile.PNG"),
                            ),
                          ),
                          child: Container()),
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ayden Tiao",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "@AydenTiao",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "20",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Friends",
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "120",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Following",
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "100",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Followers",
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                  margin: const EdgeInsets.only(right: 40),
                  decoration: const BoxDecoration(
                      color: Color(0xFF0f3e57),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: ListTile(
                    leading: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 25,
                    ),
                    title: const Text(
                      'Profile',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    onTap: () {
                      Get.offAllNamed(AppRoutes.profilePage);
                      // ...
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.upgrade_rounded,
                    size: 25,
                    color: Color(0xFFf55586),
                  ),
                  title: const Text(
                    'Upgrade',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFf55586)),
                  ),
                  onTap: () {
                    // ...
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.description_outlined,
                    size: 25,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Read',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onTap: () {
                    // ...
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.videocam,
                    size: 25,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Watch',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onTap: () {
                    // ...
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.headphones,
                    size: 25,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Listen',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onTap: () {
                    // ...
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.new_label_rounded,
                    size: 25,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'New',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onTap: () {
                    // ...
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  height: 120,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => {_globalkey.currentState!.openDrawer()},
                        child: Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.only(left: 40),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.green,
                              image: const DecorationImage(
                                image: AssetImage("assets/images/profile.PNG"),
                              ),
                            ),
                            child: Container()),
                      ),
                      const SizedBox(
                        width: 80,
                      ),
                      Image.asset("assets/images/logo.png"),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 5, top: 20),
                    child: Row(
                      children: List<Widget>.generate(
                          popularListGrouped.entries.length,
                          (index) => InkWell(
                                onTap: () {
                                  setState(() {
                                    currentCategoryIndex = index;
                                  });
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 8, bottom: 8),
                                  decoration: BoxDecoration(
                                      color: currentCategoryIndex == index
                                          ? Color(0xFF46b4b5)
                                          : Color(0xFF0f567c),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Text(
                                    popularListGrouped.entries
                                        .toList()[index]
                                        .key,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ),
                              )),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: popularListGrouped.entries
                          .toList()[currentCategoryIndex]
                          .value
                          .length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 10),
                          height: 180,
                          decoration: const BoxDecoration(
                              color: Color(0xFF103e56),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 10, top: 10, right: 5),
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.green,
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            "assets/images/profile.PNG"),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 3),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .50,
                                      child: Text(
                                        popularListGrouped.entries
                                            .toList()[currentCategoryIndex]
                                            .value[index]
                                            .profileName!,
                                        style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w300,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 3),
                                    child: popularListGrouped.entries
                                                .toList()[currentCategoryIndex]
                                                .value[index]
                                                .MPXR !=
                                            " "
                                        ? const Text("")
                                        : Row(
                                            children: [
                                              const Text(
                                                "| ",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontStyle: FontStyle.normal,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                popularListGrouped.entries
                                                    .toList()[
                                                        currentCategoryIndex]
                                                    .value[index]
                                                    .MPXR!,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                  ),
                                  Container(
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
                                          child: popularListGrouped.entries
                                                      .toList()[
                                                          currentCategoryIndex]
                                                      .value[index]
                                                      .state ==
                                                  "read"
                                              ? const Icon(
                                                  Icons.description_outlined,
                                                  color: Color(0xFF8aa7da),
                                                  size: 20,
                                                )
                                              : popularListGrouped.entries
                                                          .toList()[
                                                              currentCategoryIndex]
                                                          .value[index]
                                                          .state ==
                                                      "watch"
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
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 10, top: 10),
                                child: Text(
                                  popularListGrouped.entries
                                      .toList()[currentCategoryIndex]
                                      .value[index]
                                      .title!,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF6eded0)),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 10, top: 10, right: 20),
                                child: Text(
                                  popularListGrouped.entries
                                      .toList()[currentCategoryIndex]
                                      .value[index]
                                      .description!,
                                  maxLines: 3,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 10, bottom: 5),
                                    child: Text(
                                      popularListGrouped.entries
                                          .toList()[currentCategoryIndex]
                                          .value[index]
                                          .lastSeen!,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      popularListGrouped.entries
                                          .toList()[currentCategoryIndex]
                                          .value[index]
                                          .state!,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          popularListGrouped.entries
                                              .toList()[currentCategoryIndex]
                                              .value[index]
                                              .views!,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        const Text(
                                          "views",
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                )
              ],
            ),
      floatingActionButton: Container(
        width: 370,
        height: 100,
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 40),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                margin: EdgeInsets.only(left: 8),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 193, 78, 78),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(
                  Icons.cottage_sharp,
                  size: 40,
                  color: Colors.white,
                )),
            const Icon(
              Icons.search_outlined,
              size: 40,
              color: Colors.white,
            ),
            const Icon(
              Icons.notifications_outlined,
              size: 40,
              color: Colors.white,
            ),
            const Icon(
              Icons.email_outlined,
              size: 30,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  loadPopularList() async {
    setState(() {
      isLoading = true;
    });
    try {
      var res = await getData();
      setState(() {
        popularList = res;
        popularListGrouped["All"] = popularList;
        popularListGrouped = {
          ...popularListGrouped,
          ...popularList.groupListsBy<String>((element) => element.type!)
        };
      });
    } catch (e) {}
    setState(() {
      isLoading = false;
    });
  }
}
