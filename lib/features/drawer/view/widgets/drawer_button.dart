import 'package:flutter/material.dart';
import 'package:mindplex/features/drawer/model/drawer_types.dart';
import 'package:mindplex/utils/colors.dart';

class DrawerItemButton extends StatelessWidget {
  final DrawerType drawerType;
  final DrawerType currentDrawerType;
  final IconData icon;
  final String drawerTitle;
  final VoidCallback onTap;
  final Color? color;

  const DrawerItemButton({
    super.key,
    required this.drawerType,
    required this.currentDrawerType,
    required this.icon,
    required this.drawerTitle,
    required this.onTap,
    this.color,
  });

  bool _isHighLighted() {
    return drawerType == currentDrawerType;
  }

  @override
  Widget build(BuildContext context) {
    // define a border and padding for the highlight of the button
    const boxPadding = EdgeInsets.only(top: 5, left: 5, right: 5);

    const boxMargin = EdgeInsets.only(right: 5);
    const boxDecoration = BoxDecoration(
      color: drawerHighlight,
      borderRadius: BorderRadius.all(
        Radius.circular(20),
      ),
    );

    return InkWell(
      onTap: onTap,
      child: Container(
          margin: _isHighLighted() ? boxMargin : null,
          padding: _isHighLighted() ? boxPadding : null,
          decoration: _isHighLighted() ? boxDecoration : null,
          child: ListTile(
            leading: Icon(
              icon,
              size: 25,
              color: this.color ?? white,
            ),
            title: Text(
              drawerTitle,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: this.color ?? white),
            ),
          )),
    );
  }
}
