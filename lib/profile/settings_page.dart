import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindplex_app/auth/auth_controller/auth_controller.dart';
import 'package:mindplex_app/profile/Notifications_page.dart';
import 'package:mindplex_app/profile/change_password.dart';
import 'package:mindplex_app/profile/general_settings.dart';
import 'package:mindplex_app/profile/personal_settings.dart';
import 'package:mindplex_app/profile/preference.dart';
import 'package:mindplex_app/profile/privacy_policy_page.dart';
import 'package:mindplex_app/profile/recommendation.dart';
import 'package:mindplex_app/profile/user_profile_controller.dart';

import '../routes/app_routes.dart';
import '../utils/colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() {
    return _SettingsPage();
  }
}

class _SettingsPage extends State<SettingsPage> {
  AuthController authController = Get.put(AuthController());

  ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    profileController.getAuthenticatedUser();
    final firstName = profileController.authenticatedUser.value.firstName ?? " ";
    final userEmail = profileController.authenticatedUser.value.userEmail??" ";
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 40, left: 5, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  child: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  'Settings',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(color: Colors.lightBlue[100], borderRadius: BorderRadius.circular(100)),
                  child: CupertinoButton(
                    padding: const EdgeInsets.only(left: 3),
                    child: const Icon(
                      Icons.logout,
                      color:const Color.fromARGB(255, 2, 31, 31),
                      size: 16,
                    ),
                    onPressed: () {
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Stack(
            children: [
              buildImage(),
              Positioned(
                bottom: 0,
                right: 4,
                child: buildAddPhoto(Colors.blueGrey),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  firstName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(userEmail, style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 25, 20, 0),
            height: 2,
            color: Colors.grey[200],
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    ContainerClass(
                        context: context,
                        leading: Icons.settings,
                        title: 'General',
                        info: null,
                        trailing: Icons.arrow_forward_ios,
                        splash: true,
                        tapped: () {
                          Get.toNamed(AppRoutes.generalSettingsPage);
                        }),
                    ContainerClass(
                        context: context,
                        leading: Icons.edit,
                        title: 'Personal',
                        info: null,
                        trailing: Icons.arrow_forward_ios,
                        splash: true,
                        tapped: () {
                          Get.toNamed(AppRoutes.personalSettingsPage);
                        }),
                    ContainerClass(
                        context: context,
                        leading: Icons.change_circle,
                        title: 'Password',
                        info: null,
                        trailing: Icons.arrow_forward_ios,
                        splash: true,
                        tapped: () {
                          Get.toNamed(AppRoutes.changePasswordPage);

                        }),
                    ContainerClass(
                        context: context,
                        leading: Icons.star,
                        title: 'Recommendation',
                        info: null,
                        trailing: Icons.arrow_forward_ios,
                        splash: true,
                        tapped: () {
                          Get.toNamed(AppRoutes.recommendationPage);

                        }),
                    ContainerClass(
                        context: context,
                        leading: Icons.person,
                        title: 'Preferences',
                        info: null,
                        trailing: Icons.arrow_forward_ios,
                        splash: true,
                        tapped: () {
                          Get.toNamed(AppRoutes.preferencePage);

                        }),
                    ContainerClass(
                        context: context,
                        leading: Icons.notifications_none_rounded,
                        title: 'Notifications',
                        info: null,
                        trailing: Icons.arrow_forward_ios,
                        splash: true,
                        tapped: () {
                          Get.toNamed(AppRoutes.notificationsPage);

                        }),
                    ContainerClass(
                        context: context,
                        leading: Icons.privacy_tip_outlined,
                        title: 'Privacy Policy',
                        info: null,
                        trailing: Icons.arrow_forward_ios,
                        splash: true,
                        tapped: () {
                          Get.toNamed(AppRoutes.privacyPolicyPage);

                        }),
                    ContainerClass(
                        context: context,
                        leading: Icons.share,
                        title: 'Invite Friends',
                        info: null,
                        trailing: Icons.arrow_forward_ios,
                        splash: true,
                        tapped: () {}),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  buildAddPhoto(MaterialColor blue) {
    IconThemeData icon = Theme.of(context).iconTheme;
    return ClipOval(
      child: Container(
        padding: const EdgeInsets.all(5),
        color: Colors.cyan,
        child: InkWell(
            onTap: () async {
              String? filePath = await pickImage();
              // let's show a loading dialog with a loading message
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) => const Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                ),
              );
              // let's upload the image to the api
              if (filePath != null) {
                // let's try to upload the image

                // try {
                //   String imageUrl = await ApiProvider().changeProfilePicture(filePath);
                //   setState(() {
                //     image = imageUrl;
                //   });
                //   UserPreferences.setProfilePicture(imageUrl);
                //   var landingPageController = Get.find<LandingPageController>();
                //   landingPageController.profileImage = imageUrl;
                // } catch (error) {
                //   // let's show an error message
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(
                //       content: Text("Failed to upload image. Try again later."),
                //     ),
                //   );
                // }
              } else {
                // display a snackbar with error message (to the user)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Invalid file selected."),
                  ),
                );
              }
              // pop the dialog
              Navigator.pop(context);
            },
            child: Icon(
              Icons.mode_edit_outline_outlined,
              color: icon.color,
              size: 17,
            )),
      ),
    );
  }
  Future<String?> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    String filepath = '';
    if (pickedImage != null) {
      filepath = pickedImage.path;
      return filepath;
    }
    return null;
  }
  Widget buildImage() {
    ImageProvider<Object> image = NetworkImage(
      profileController.authenticatedUser.value.image ??
          "assets/images/profile.PNG",
    );
    return CircleAvatar(
      radius: 45,
      foregroundImage: image,
      child: const Material(
        color: Color.fromARGB(0, 231, 6, 6), //
      ),
    );
  }
}
class ContainerClass extends StatelessWidget {
  const ContainerClass({
    Key? key,
    required this.context,
    required this.leading,
    required this.title,
    required this.info,
    required this.trailing,
    required this.splash,
    required this.tapped,
  }) : super(key: key);

  final BuildContext context;
  final IconData leading;
  final String title;
  final Widget? info;
  final IconData? trailing;
  final bool splash;
  final VoidCallback tapped;

  @override
  Widget build(context) {
    double radius = 30;
    const mainColor = Colors.black;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 73, 150, 154),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                offset: const Offset(1, 1),
                color: const Color.fromARGB(54, 188, 187, 187),
              )
            ],
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: tapped,
              highlightColor: splash
                  ? const Color.fromARGB(132, 135, 208, 245)
                  : Colors.transparent,
              splashColor: splash
                  ? const Color.fromARGB(61, 231, 231, 231)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(radius),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            left: 15, top: 10, bottom: 10),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(color: Colors.lightBlue[100],
                            borderRadius: BorderRadius.circular(100)),
                        child: Icon(
                          leading,
                          color: mainColor,
                          size: 18,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(title, style: TextStyle(fontSize: 17,color: Colors.white)), //15
                    ],
                  ),
                  Row(
                    children: [
                      info ?? Container(),
                      const SizedBox(
                        width: 10,
                      ),
                      trailing == null
                          ? Container()
                          : Container(
                        margin: const EdgeInsets.only(right: 15),
                        child: Icon(
                          trailing,
                          color: Colors.white,
                          size: 20,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}