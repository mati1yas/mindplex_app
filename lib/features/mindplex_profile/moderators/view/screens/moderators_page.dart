import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/drawer/controller/drawer_controller.dart';
import 'package:mindplex/features/drawer/model/drawer_types.dart';

import '../widgets/moderator_applicationform_widget.dart';
import '../widgets/moderator_card.dart';

class ModeratorsPage extends StatelessWidget {
  ModeratorsPage({super.key});
  DrawerButtonController drawerButtonController = Get.find();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return PopScope(
      onPopInvoked: (bool didPop) {
        drawerButtonController.changeDrawerType(DrawerType.read);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 6, 46, 59),
          body: ListView(
            children: [
              Material(
                elevation: 10,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          drawerButtonController
                              .changeDrawerType(DrawerType.read);
                          Get.back();
                        },
                        icon: Icon(Icons.arrow_back),
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: width * 0.18,
                      ),
                      Center(
                          child: Text(
                        "Our Moderatores",
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      )),
                    ],
                  ),
                  height: 70,
                ),
                color: Color.fromARGB(255, 6, 46, 59),
              ),
              SizedBox(
                height: 10,
              ),
              ModeratorCard(
                  moderatorImage: 'assets/images/default_user.jpeg',
                  moderatorName: "Henderson Robert",
                  moderatorRole: "Moderator",
                  moderatorBio:
                      "My name is Henderson Robert, I’ve been an online content moderator for mindplex..."),
              ModeratorApplicationForm()
            ],
          ),
        ),
      ),
    );
  }
}
