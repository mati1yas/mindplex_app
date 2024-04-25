import 'dart:ui';

import 'package:flutter/material.dart';

Widget buildButton(String label, VoidCallback onTap, Color color1, bool fill,
    BuildContext context) {
  return SizedBox(
    key: UniqueKey(),
    width: MediaQuery.of(context).size.width * 0.4,
    height: 40,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: fill
            ? BoxDecoration(
                color: color1,
                borderRadius: BorderRadius.circular(10),
              )
            : BoxDecoration(
                border: Border.all(color: color1),
                borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            label,
            style: fill
                ? TextStyle(color: Colors.white, fontSize: 20)
                : TextStyle(color: color1, fontSize: 20),
          ),
        ),
      ),
    ),
  );
}
