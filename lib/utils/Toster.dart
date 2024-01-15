import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void Toster({required String message,Color? color,int duration = 5}) {
  Flushbar(
    flushbarPosition: FlushbarPosition.BOTTOM,
    margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
    titleSize: 20,
    messageSize: 17,
    messageColor: color == null?Colors.red:Colors.white,
    backgroundColor: color == null?Colors.white:color,
    borderRadius: BorderRadius.circular(8),
    message: message,
    duration: Duration(seconds: duration),
  )..show(Get.context!);
}
