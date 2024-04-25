import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

void showSnackBar({
  required BuildContext context,
  required String title,
  required String message,
  required String type,
}) {
  var contentType;
  if (type == 'failure') {
    contentType = ContentType.failure;
  } else if (type == 'success') {
    contentType = ContentType.success;
  } else {
    contentType = ContentType.warning;
  }

  var snackBar = SnackBar(
    duration: Duration(seconds: 2),
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      messageFontSize: 13,
      title: title,
      message: message,
      contentType: contentType,
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
