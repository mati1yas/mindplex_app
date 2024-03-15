import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget noInternetCard(VoidCallback onRefresh, String? message) {
  return Container(
    width: MediaQuery.of(Get.context!).size.width * 0.65,
    height: 150,
    margin: EdgeInsets.all(15.0),
    padding: EdgeInsets.all(15),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: Colors.white70),
    child: Column(
      children: [
        GestureDetector(
          onTap: onRefresh,
          child: Icon(
            Icons.refresh_outlined,
            size: 35,
            color: Colors.red,
          ),
        ),
        Text(
          message ??
              "Looks like you have a problem with your internet connection",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        )
      ],
    ),
  );
}
