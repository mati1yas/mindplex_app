import 'package:flutter/widgets.dart';
import 'package:mindplex/features/drawer/model/drawer_types.dart';

class DrawerModel {
  final String drawerName;
  final String pageName;
  final String? postType;
  final String? postFormat;
  final DrawerType drawerType;
  final IconData icon;
  final Color? color;
  final bool? requiresPrivilege;
  final dynamic parameters;

  DrawerModel({
    required this.drawerName,
    required this.pageName,
    this.postType,
    this.postFormat,
    required this.drawerType,
    required this.icon,
    this.color,
    this.requiresPrivilege,
    this.parameters,
  });
}
