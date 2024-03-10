import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/blogs/view/screens/landing_page.dart';
import 'package:mindplex/features/bottom_navigation_bar/controllers/bottom_page_navigation_controller.dart';
import 'package:mindplex/features/drawer/controller/drawer_controller.dart';
import 'package:mindplex/features/drawer/view/widgets/drawer_widget.dart';
import 'package:mindplex/features/interaction/controllers/like_dislike_controller.dart';
import 'package:mindplex/features/user_profile_displays/controllers/DraftedPostsController.dart';
import 'package:mindplex/routes/app_routes.dart';
import 'package:mindplex/features/search/view/screens/search_page.dart';
import 'package:mindplex/features/groups/view/screens/groups_page.dart';
import 'package:mindplex/features/notification/view/screens/notification_page.dart';
import 'package:mindplex/features/chat/view/screens/message_page.dart';
import 'package:mindplex/utils/constatns.dart';

import 'features/authentication/controllers/auth_controller.dart';
import 'features/blogs/controllers/blogs_controller.dart';
import 'features/notification/controllers/notification_controller.dart';
import 'features/user_profile_displays/controllers/user_profile_controller.dart';
import 'splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: false),
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
  BlogsController blogsController = Get.put(BlogsController());

  NotificationController notificationController =
      Get.put(NotificationController());

  PageNavigationController pageNavigationController =
      Get.put(PageNavigationController());

  LikeDislikeConroller likeDislikeConroller = Get.put(LikeDislikeConroller());

  ProfileController profileController = Get.put(ProfileController());
  DraftedPostsController draftedPostsController =
      Get.put(DraftedPostsController());
  DrawerButtonController drawerButtonController =
      Get.put(DrawerButtonController());

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
