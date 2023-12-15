import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/blogs/landing_page.dart';
import 'package:mindplex/bottom_nav_bar/bottom_page_navigation_controller.dart';
import 'package:mindplex/drawer/drawer_widget.dart';
import 'package:mindplex/routes/app_routes.dart';
import 'package:mindplex/search/search_page.dart';
import 'package:mindplex/groups/groups_page.dart';
import 'package:mindplex/notification/notification_page.dart';
import 'package:mindplex/message/message_page.dart';
import 'package:mindplex/utils/constatns.dart';

import 'auth/auth_controller/auth_controller.dart';
import 'blogs/blogs_controller.dart';
import 'notification/controller/notification_controller.dart';
import 'profile/user_profile_controller.dart';
import 'splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppRoutes.home,
      getPages: AppRoutes.pages,
      title: 'MindPlex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageNavigationController pageNavigationController =
      Get.put(PageNavigationController());
  NotificationController notificationController =
      Get.put(NotificationController());

  BlogsController blogsController = Get.put(BlogsController());

  ProfileController profileController = Get.put(ProfileController());
  AuthController authController = Get.find();
  final pages = [
    LandingPage(),
    SearchPage(),
    GroupsPage(),
    NotificationPage(),
    MessagePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Keys.globalkey,
      drawer: Drawer(
        child: DrawerWidget(),
      ),
      body: Stack(
        children: [
          //  main page to be display
          Obx(() => pages[pageNavigationController.currentPage.value]),

          //  bottom navigation par
          Obx(
            () => Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 12, right: 12),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50)),
                  height: 45,
                  child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              pageNavigationController.navigatePage(0);
                            },
                            child: Icon(
                              Icons.home_outlined,
                              color:
                                  pageNavigationController.currentPage.value ==
                                          0
                                      ? Colors.green
                                      : Colors.white,
                              size:
                                  pageNavigationController.currentPage.value ==
                                          0
                                      ? 29
                                      : 24,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              pageNavigationController.navigatePage(1);
                            },
                            child: Icon(
                              Icons.search,
                              color:
                                  pageNavigationController.currentPage.value ==
                                          1
                                      ? Colors.green
                                      : Colors.white,
                              size:
                                  pageNavigationController.currentPage.value ==
                                          1
                                      ? 29
                                      : 24,
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     pageNavigationController.navigatePage(2);
                          //   },
                          //   child: Icon(
                          //     Icons.people_outline,
                          //     color:
                          //         pageNavigationController.currentPage.value ==
                          //                 2
                          //             ? Colors.green
                          //             : Colors.white,
                          //     size:
                          //         pageNavigationController.currentPage.value ==
                          //                 2
                          //             ? 29
                          //             : 24,
                          //   ),
                          // ),
                          GestureDetector(
                            onTap: () {
                              if (authController.isGuestUser.value) {
                                authController.guestReminder(context);
                              } else {
                                pageNavigationController.navigatePage(3);

                                notificationController.loadNotifications();
                              }
                            },
                            child: Icon(
                              Icons.notifications_outlined,
                              color:
                                  pageNavigationController.currentPage.value ==
                                          3
                                      ? Colors.green
                                      : Colors.white,
                              size:
                                  pageNavigationController.currentPage.value ==
                                          3
                                      ? 29
                                      : 24,
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     if (authController.isGuestUser.value) {
                          //       authController.guestReminder(context);
                          //     } else {
                          //       pageNavigationController.navigatePage(4);
                          //     }
                          //   },
                          //   child: Icon(
                          //     Icons.email_outlined,
                          //     color:
                          //         pageNavigationController.currentPage.value ==
                          //                 4
                          //             ? Colors.green
                          //             : Colors.white,
                          //     size:
                          //         pageNavigationController.currentPage.value ==
                          //                 4
                          //             ? 29
                          //             : 24,
                          //   ),
                          // ),
                        ]),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
