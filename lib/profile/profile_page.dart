import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex_app/auth/auth.dart';
import 'package:mindplex_app/profile/user_profile_controller.dart';
import 'package:mindplex_app/routes/app_routes.dart';
import 'package:mindplex_app/utils/colors.dart';
import 'package:transparent_image/transparent_image.dart';

import '../auth/auth_controller/auth_controller.dart';
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

class _ProfilePage extends State<ProfilePage> {
  AuthController authController = Get.put(AuthController());
  //array og pages
  final double coverHeight = 280;

  bool isWalletConnected = false;

  Widget activeScreen = const AboutScreen();

  //make this an object with 3 values
  //1 of widget
  //2 activeStatus of boolean
  //3 identifier of int

  void switchScreen(int num) {
    setState(() {
      switch (num) {
        case 1:
          activeScreen = const AboutScreen();
          break;
        case 2:
          activeScreen = const BookmarkScreen();
          break;
        case 3:
          activeScreen = const DraftScreen();
          break;
        default:
      }
    });
  }

  void switchWallectConnectedState() {
    setState(() {
      isWalletConnected = true;
    });
  }

  ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    profileController.getAuthenticatedUser();
    return Scaffold(
        backgroundColor: mainBackgroundColor, // can and should be removed
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              buildTop(),
              buildUserName(),
              buildStatus(),
              buidScreens(),
              buildTab(),
            ],
          ),
        ));
  }

  Widget buildCoverImage() {
    // decoration:BoxDecoration()), add curves to the image
    return ClipRRect(
      borderRadius: BorderRadius.circular(coverHeight * 0.5),
      child: FadeInImage(
        placeholder: MemoryImage(kTransparentImage),
        image: NetworkImage(
          profileController.authenticatedUser.value.image ??
              "assets/images/profile.PNG",
        ),
        fit: BoxFit.cover,
        width: coverHeight,
        height: coverHeight,
      ),
    );
  }

  Widget buildTop() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20, top: 20),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            buildCoverImage(),
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
                            Navigator.of(context).pop();
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

  Widget buildUserName() {
    final firstName =
        profileController.authenticatedUser.value.firstName ?? " ";
    final lastName = profileController.authenticatedUser.value.lastName ?? " ";

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
                profileController.authenticatedUser.value.username ?? "",
                style: TextStyle(
                  color: Color.fromARGB(255, 190, 190, 190),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              // OutlinedButton(onPressed: onPressed, child: child)
            ],
          ),
          if (!isWalletConnected)
            OutlinedButton(
              onPressed: switchWallectConnectedState,
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  minimumSize: Size(117, 37),
                  backgroundColor: const Color.fromARGB(255, 225, 62, 111),
                  foregroundColor: Colors.white),
              child: const Text(
                'Connect Wallet',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildStatus() {
    var status = [
      {"amount": "20", "value": "Friends"},
      {"amount": "120", "value": "Following"},
      {"amount": "100", "value": "Followers"},
      {"amount": "100", "value": " MPXR"}
    ];
    return Container(
      height: 46,
      margin: const EdgeInsets.only(bottom: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /*
        ...status.map(
          (item) {
            return Row(
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
                Container(
                  height: 40.0,
                  width: 1.0,
                  color: const Color.fromARGB(255, 73, 150, 154),
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                ), //straight line after each value
              ],
            );
          },
        ),

*/

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

  Widget buidScreens() {
    return Column(
      children: [
        Container(
          height: 33,
          width: MediaQuery.sizeOf(context).width - 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: profileController.screens.length,
            itemBuilder: (context, index) {
              String selectedTab =
                  profileController.screens[index]["name"].toString();

              return GestureDetector(
                onTap: () {
                  profileController.switchTab(tab: selectedTab);
                  switchScreen(profileController.screens[index]['num'] as int);
                },
                child: Obx(
                  () => Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 8, bottom: 8),
                    decoration: BoxDecoration(
                        color: profileController.selectedTabCategory.value ==
                                selectedTab
                            ? Color.fromARGB(255, 137, 69, 118)
                            : Color(0xFF0f567c),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Center(
                      child: Text(
                        selectedTab,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildTab() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
      height: 320,
      width: 320,
      child: activeScreen,
    );
  }
}
