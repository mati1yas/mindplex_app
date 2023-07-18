import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mindplex_app/provider/popularProvider.dart';
import 'package:mindplex_app/services/PopularServices.dart';
import 'package:provider/provider.dart';

import '../Models/popularModel.dart';

class PopularScreen extends StatefulWidget {
  const PopularScreen({super.key});

  @override
  State<PopularScreen> createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen> {
  List<PopularDetails> popularList = [];
  Map<String, List<PopularDetails>> popularListGrouped = {};

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

  // _getEventCategory(String status) {
  //   switch (status) {
  //     case "Popular":
  //       popularList = popularList.forEach((element) {
  //         if (element.type == "Popular") {}
  //       });
  //   }
  // }

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
      drawer: Container(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  height: 120,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                          height: 40,
                          width: 40,
                          margin: EdgeInsets.only(left: 40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.green,
                            image: DecorationImage(
                              image: AssetImage("assets/images/profile.PNG"),
                            ),
                          ),
                          child: Container()),
                      SizedBox(
                        width: 80,
                      ),
                      Image.asset("assets/images/logo.png"),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5, top: 20),
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
                                      borderRadius: BorderRadius.all(
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
                          margin:
                              EdgeInsets.only(left: 20, right: 20, bottom: 10),
                          height: 180,
                          decoration: BoxDecoration(
                              color: Color(0xFF103e56),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 10, top: 10, right: 5),
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.green,
                                      image: DecorationImage(
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
                                        style: TextStyle(
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
                                              Text(
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
                                                style: TextStyle(
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
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(5),
                                          bottomRight: Radius.circular(5),
                                        )),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: popularListGrouped.entries
                                                      .toList()[
                                                          currentCategoryIndex]
                                                      .value[index]
                                                      .state ==
                                                  "read"
                                              ? Icon(
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
                                                  ? Icon(
                                                      Icons.videocam,
                                                      color: Color.fromARGB(
                                                          255, 185, 127, 127),
                                                      size: 20,
                                                    )
                                                  : Icon(
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
                                margin: EdgeInsets.only(left: 10, top: 10),
                                child: Text(
                                  popularListGrouped.entries
                                      .toList()[currentCategoryIndex]
                                      .value[index]
                                      .title!,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF6eded0)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10, top: 10, right: 20),
                                child: Text(
                                  popularListGrouped.entries
                                      .toList()[currentCategoryIndex]
                                      .value[index]
                                      .description!,
                                  maxLines: 3,
                                  style: TextStyle(
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 10, bottom: 5),
                                    child: Text(
                                      popularListGrouped.entries
                                          .toList()[currentCategoryIndex]
                                          .value[index]
                                          .lastSeen!,
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      popularListGrouped.entries
                                          .toList()[currentCategoryIndex]
                                          .value[index]
                                          .state!,
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          popularListGrouped.entries
                                              .toList()[currentCategoryIndex]
                                              .value[index]
                                              .views!,
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(
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
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 40),
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
                child: Icon(
                  Icons.cottage_sharp,
                  size: 40,
                  color: Colors.white,
                )),
            Icon(
              Icons.search_outlined,
              size: 40,
              color: Colors.white,
            ),
            Icon(
              Icons.notifications_outlined,
              size: 40,
              color: Colors.white,
            ),
            Icon(
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
