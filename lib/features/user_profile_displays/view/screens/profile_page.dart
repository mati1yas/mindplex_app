import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/authentication/view/screens/auth.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';
import 'package:mindplex/features/user_profile_displays/view/screens/publish_posts.dart';
import 'package:mindplex/routes/app_routes.dart';
import 'package:mindplex/utils/colors.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../authentication/controllers/auth_controller.dart';
import 'about_screen.dart';
import 'bookmark_screen.dart';
import 'draft_screen.dart';

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
  ProfileController profileController = Get.find();
  late TabController _tabController;
  Map<String, String?> params = Get.parameters;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    profileController.getAuthenticatedUser();

    if (params['me'] == 'me') {
      profileController.getUserProfile(
          username: profileController.authenticatedUser.value.username ?? "");
    } else {
      profileController.getUserProfile(username: params["username"] ?? "");
    }
  }

  final double coverHeight = 280;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mainBackgroundColor, // can and should be removed
        body: SafeArea(
          child: Obx(() => profileController.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    buildTop(params),
                    buildUserName(params),
                    buildStatus(params),
                    buidScreens(params),
                  ],
                )),
        ));
  }

  Widget buildCoverImage(dynamic params) {
    // decoration:BoxDecoration()), add curves to the image
    return CircleAvatar(
      backgroundColor: Colors.green,
      radius: MediaQuery.of(context).size.width * 0.25,
      backgroundImage: NetworkImage(
        params['me'] == 'me'
            ? profileController.authenticatedUser.value.image ??
                "assets/images/profile.PNG"
            : profileController.userProfile.value.avatarUrl ??
                "assets/images/profile.PNG",
      ),
    );
  }

  Widget buildTop(dynamic params) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20, top: 20),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            buildCoverImage(params),
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
      ),
    );
  }

  Widget buildUserName(dynamic params) {
    final firstName = profileController.userProfile.value.firstName ?? " ";
    final lastName = profileController.userProfile.value.lastName ?? " ";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 5),
                child: Text(
                  firstName + " " + lastName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                profileController.userProfile.value.username ?? "",
                style: TextStyle(
                  color: Color.fromARGB(255, 190, 190, 190),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              // OutlinedButton(onPressed: onPressed, child: child)
            ],
          ),
          if (params['me'] == 'me')
            Obx(() => profileController.isWalletConnected.value
                ? SizedBox(
                    width: 0,
                    height: 0,
                  )
                : OutlinedButton(
                    onPressed: profileController.switchWallectConnectedState,
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
                  )),
        ],
      ),
    );
  }

  Widget buildStatus(dynamic params) {
    var status = [
      {
        "amount": profileController.authenticatedUser.value.friends.toString(),
        "value": "Friends"
      },
      {
        "amount":
            profileController.authenticatedUser.value.followings.toString(),
        "value": "Following"
      },
      {
        "amount":
            profileController.authenticatedUser.value.followers.toString(),
        "value": "Followers"
      },
      {"amount": "100", "value": " MPXR"}
    ];
    return Container(
      height: 46,
      margin: const EdgeInsets.only(bottom: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (var item in status)
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      item['amount'].toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      item['value'].toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 190, 190, 190),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                if (status.indexOf(item) != status.length - 1)
                  Container(
                    height: 40.0,
                    width: 1.0,
                    color: const Color.fromARGB(255, 73, 150, 154),
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                  ), //
              ],
            ),
        ],
      ),
    );
  }

  Widget buidScreens(dynamic params) {
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
              Tab(text: "Bookmarks"),
              Tab(text: "Drafts"),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
          height: 320,
          width: 340,
          child: TabBarView(controller: _tabController, children: [
            AboutScreen(),
            PublishedPosts(),
            BookmarkScreen(),
            DraftScreen()
          ]),
        ),
      ],
    );
  }
}
