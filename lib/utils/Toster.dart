import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void Toster({required String message}) {
  Flushbar(
    flushbarPosition: FlushbarPosition.BOTTOM,
    margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
    titleSize: 20,
    messageSize: 17,
    messageColor: Colors.red,
    backgroundColor: Colors.white,
    borderRadius: BorderRadius.circular(8),
    message: message,
    duration: const Duration(seconds: 5),
  )..show(Get.context!);
}
