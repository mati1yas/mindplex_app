import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mindplex_app/notification/controller/notification_controller.dart';
import 'package:mindplex_app/notification/widgets/notification_card_widget.dart';

import '../blogs/blogs_controller.dart';
import '../drawer/drawer_widget.dart';
import '../profile/user_profile_controller.dart';
import '../utils/constatns.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  BlogsController blogsController = Get.put(BlogsController());
  ProfileController profileController = Get.find();
  NotificationController notificationController = Get.find();

  GlobalKey<ScaffoldState> globalkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: Keys.globalkey,
      body: Container(
        color: Color(0xFF0c2b46),
        child: Column(
          children: [
            Container(
              color: Color.fromARGB(255, 5, 32, 54),
              height: height * 0.20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => {Keys.globalkey.currentState!.openDrawer()},
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                          profileController.authenticatedUser.value.image ??
                              ""),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Notifications",
                        style: TextStyle(
                            fontSize: height * 0.04,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: height * 0.20 * 0.25,
                        // width: 200,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(59, 166, 166, 174),
                            borderRadius: BorderRadius.circular(12)),

                        child: TabBar(
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color.fromARGB(255, 49, 153, 167)),
                            isScrollable: true,
                            controller: tabController,
                            tabs: [
                              Tab(
                                child: Container(
                                  width: 80,
                                  child: Text(
                                    "All",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Tab(
                                child: Container(
                                  width: 80,
                                  child: Text(
                                    "Mentions",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ]),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
            Obx(() =>
                notificationController.isLoadingNotifications.value == false
                    ? Container(
                        height: height * 0.795,
                        child: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            controller: tabController,
                            children: [
                              Container(
                                height: 510,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: notificationController
                                        .notificationList.length,
                                    itemBuilder: (ctx, index) {
                                      return NotificationCard(
                                        notification: notificationController
                                            .notificationList[index],
                                      );
                                    }),
                              ),
                              Container(
                                height: height * 0.795,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: notificationController
                                        .notificationList.length,
                                    itemBuilder: (ctx, index) {
                                      return NotificationCard(
                                        notification: notificationController
                                            .notificationList[index],
                                      );
                                    }),
                              ),
                            ]),
                      )
                    : Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )),
          ],
        ),
      ),
    );
  }
}
