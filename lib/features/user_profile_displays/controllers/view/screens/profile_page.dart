import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';
import 'package:mindplex/features/user_profile_displays/view/screens/publish_posts.dart';
import 'package:mindplex/utils/colors.dart';
import 'package:mindplex/features/authentication/controllers/auth_controller.dart';
import '../widgets/user_profile_image_widget.dart';
import '../widgets/user_profile_statistics_widget.dart';
import './about_screen.dart';
import './bookmark_screen.dart';
import './draft_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() {
    return _ProfilePage();
  }
}

class _ProfilePage extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  AuthController authController = Get.find();
  late TabController _tabController;
  Map<String, String?> params = Get.parameters;

  ProfileController userProfileController = Get.find();

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: params['me'] == 'me' ? 4 : 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    userProfileController.getAuthenticatedUser();
    print(["userName", params["username"]]);
    userProfileController.getUserProfile(
        username: params["me"] == "me"
            ? userProfileController.authenticatedUser.value.username!
            : params["username"]!);

    return Scaffold(
        backgroundColor: mainBackgroundColor, // can and should be removed
        body: SafeArea(
          child: Obx(() => userProfileController.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    buildTop(params),
                    buildUserNameSection(params),
                    UserProfileStatistics(
                        profileController: userProfileController),
                    buidScreens(params),
                  ],
                )),
        ));
  }

  Widget buildTop(dynamic params) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, top: 20),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          UserProfileImage(
            context: context,
            profileController: userProfileController,
            me: params['me'] == 'me',
          ),
          Positioned(
            top: 0,
            left: 5,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 5,
            child: PopupMenuButton(
                color: Colors.white,
                itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () {
                          authController.logout();
                          // Navigator.of(context).pop();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.logout),
                            Text("Logout"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.info),
                            Text("Change info"),
                          ],
                        ),
                      ),
                    ]),
          ),
        ],
      ),
    );
  }

  Widget buildUserNameSection(dynamic params) {
    final firstName = userProfileController.userProfile.value.firstName ?? " ";
    final lastName = userProfileController.userProfile.value.lastName ?? " ";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              padding: const EdgeInsets.only(right: 10),
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      firstName + " " + lastName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    userProfileController.userProfile.value.username ?? "",
                    style: TextStyle(
                      color: Color.fromARGB(255, 190, 190, 190),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // OutlinedButton(onPressed: onPressed, child: child)
                ],
              )),
          if (params['me'] == 'me')
            Obx(() => userProfileController.isWalletConnected.value
                ? SizedBox(
                    width: 0,
                    height: 0,
                  )
                : Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: OutlinedButton(
                      onPressed:
                          userProfileController.switchWallectConnectedState,
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          minimumSize: Size(117, 37),
                          backgroundColor:
                              const Color.fromARGB(255, 225, 62, 111),
                          foregroundColor: Colors.white),
                      child: const Text(
                        'Connect Wallet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ))),
        ],
      ),
    );
  }

  Widget buidScreens(dynamic params) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          height: 35,
          decoration: BoxDecoration(
            color: Color.fromARGB(50, 118, 118, 128),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TabBar(
            isScrollable: true,
            dividerColor: Colors.grey,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromARGB(255, 49, 153, 167)),
            indicatorColor: Colors.green,
            controller: _tabController,
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w300),
            tabs: [
              Tab(
                text: "About",
              ),
              Tab(text: "Published Content"),
              if (params['me'] == 'me') Tab(text: "Bookmarks"),
              if (params['me'] == 'me') Tab(text: "Drafts"),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
          height: height * 0.55,
          width: width * 0.95,
          child: TabBarView(controller: _tabController, children: [
            AboutScreen(),
            PublishedPosts(),
            if (params['me'] == 'me') BookmarkScreen(),
            if (params['me'] == 'me') DraftScreen(),
          ]),
        ),
      ],
    );
  }
}
