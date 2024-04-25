import 'package:flutter/material.dart';

Widget errorMessage(String? error) {
  return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(top: 5, left: 10),
      child: Text(
        error.toString(),
        style: const TextStyle(color: Colors.red),
      ));
}
