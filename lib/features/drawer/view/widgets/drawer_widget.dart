import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/drawer/controller/drawer_controller.dart';
import 'package:mindplex/features/drawer/model/drawer_items.dart';
import 'package:mindplex/features/drawer/model/drawer_model.dart';
import 'package:mindplex/features/drawer/view/widgets/drawer_button.dart';
import 'package:mindplex/features/drawer/view/widgets/guest_user_widget.dart';
import 'package:mindplex/features/drawer/view/widgets/logged_user_widget.dart';

import '../../../authentication/controllers/auth_controller.dart';
import '../../../../routes/app_routes.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({
    super.key,
  });
  final AuthController _authController = Get.find();
  final DrawerButtonController _drawerButtonController = Get.find();

  @override
  Widget build(BuildContext context) {
    final List<DrawerModel> drawers = DrawerItems.drawers;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF062f46), Color(0xFF1d253d)],
      )),
      child: ListView(
        padding: EdgeInsets.only(top: 20, left: 20),
        children: [
          Obx(
            () => _authController.isGuestUser.value
                ? GuestUser()
                : LoggedInUserWidget(),
          ),
          const SizedBox(
            height: 20,
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: drawers.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return DrawerItemButton(
                  icon: drawers[index].icon,
                  drawerType: drawers[index].drawerType,
                  currentDrawerType:
                      _drawerButtonController.currentDrawerType.value,
                  drawerTitle: drawers[index].drawerName,
                  color: drawers[index].color,
                  onTap: () {
                    _drawerButtonController.navigateToPage(drawers[index]);
                  },
                );
              }),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "© 2023 MindPlex. All rights reserved",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                child: Icon(
                  Icons.settings,
                  size: 32,
                  color: Colors.white,
                ),
                onTap: () {
                  if (_authController.isGuestUser.value) {
                    _authController.guestReminder(context);
                  } else {
                    Navigator.of(context).pop();
                    Get.toNamed(AppRoutes.settingsPage);
                  }
                },
              ),
              SizedBox(
                width: 15,
              )
            ],
          ),
          SizedBox(
            height: 60,
          )
        ],
      ),
    );
  }
}
