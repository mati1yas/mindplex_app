import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mindplex/features/drawer/model/drawer_model.dart';
import 'package:mindplex/routes/app_routes.dart';
import 'package:mindplex/utils/colors.dart';

import 'drawer_types.dart';

class DrawerItems {
  static final List<DrawerModel> drawers = [
    DrawerModel(
      drawerName: "Profile",
      pageName: AppRoutes.profilePage,
      drawerType: DrawerType.profile,
      icon: Icons.person,
      parameters: {'me': 'me', 'username': ''},
      requiresPrivilege: true,
    ),
    // DrawerModel(
    //   icon: Icons.upgrade_rounded,
    //   drawerName: "Upgrade",
    //   color: upgradeColor,
    //   drawerType: DrawerType.upgrade,
    //   pageName: '/upgrade',
    // ),
    DrawerModel(
      icon: Icons.description_outlined,
      drawerName: "Read",
      pageName: AppRoutes.landingPage,
      drawerType: DrawerType.read,
      postType: "articles",
      postFormat: "text",
    ),
    DrawerModel(
      icon: Icons.videocam,
      drawerName: "Watch",
      pageName: AppRoutes.landingPage,
      drawerType: DrawerType.watch,
      postType: "articles",
      postFormat: "video",
    ),
    DrawerModel(
      icon: Icons.headphones,
      drawerName: "Listen",
      pageName: AppRoutes.landingPage,
      drawerType: DrawerType.listen,
      postType: "articles",
      postFormat: "audio",
    ),
    DrawerModel(
      icon: Icons.new_label_rounded,
      drawerName: "News",
      pageName: AppRoutes.landingPage,
      drawerType: DrawerType.news,
      postType: "news",
      postFormat: "text",
    ),
    DrawerModel(
      icon: FontAwesome.cube,
      drawerName: "Topics",
      pageName: AppRoutes.landingPage,
      drawerType: DrawerType.topics,
      postType: "topics",
      postFormat: "0",
    ),
    DrawerModel(
      icon: Icons.groups,
      drawerName: "Community Contents",
      pageName: AppRoutes.landingPage,
      drawerType: DrawerType.community,
      postType: "community_content",
      postFormat: "all",
    ),
    DrawerModel(
      icon: Icons.people_outline_sharp,
      drawerName: "Social Feed",
      pageName: AppRoutes.landingPage,
      drawerType: DrawerType.social,
      postType: "social",
      postFormat: "all",
    ),
    DrawerModel(
      icon: Icons.help_outline,
      drawerName: "FAQ",
      drawerType: DrawerType.faq,
      pageName: "/faq",
    ),
    DrawerModel(
      icon: Icons.people_alt_sharp,
      drawerName: "Moderators",
      drawerType: DrawerType.moderators,
      pageName: AppRoutes.moderators,
    ),
    DrawerModel(
      icon: Icons.people_alt_sharp,
      drawerName: "About us",
      drawerType: DrawerType.about,
      pageName: AppRoutes.aboutPage,
    ),
  ];
}
