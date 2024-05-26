import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/drawer/controller/drawer_controller.dart';
import 'package:mindplex/features/drawer/model/drawer_types.dart';

//  used this bar as common for the following page about minddple, contributors, privacy , terms , constitution .
class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.height,
    required this.width,
    required this.drawerButtonController,
    required this.pageName,
  });

  final double height;
  final double width;
  final DrawerButtonController drawerButtonController;
  final String pageName;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      child: Container(
        height: height * 0.1,
        width: width,
        alignment: Alignment.center,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                drawerButtonController.changeDrawerType(DrawerType.read);
                Get.back();
              },
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
            ),
            Spacer(),
            Center(
                child: Text(
              pageName,
              style: TextStyle(color: Colors.white, fontSize: 22),
            )),
            Spacer(),
            SizedBox(
              width: 25,
            )
          ],
        ),
      ),
      color: Color.fromARGB(255, 6, 46, 59),
    );
  }
}
