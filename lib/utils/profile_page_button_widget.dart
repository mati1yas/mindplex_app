import 'package:flutter/material.dart';

class ProfilePageOutlinedButton extends StatelessWidget {
  final String buttonName;
  final VoidCallback buttonAction;
  final Color buttonColor;
  final double buttonWidthFactor;
  final double buttonRadius;
  const ProfilePageOutlinedButton(
      {super.key,
      required this.buttonName,
      required this.buttonAction,
      required this.buttonColor,
      required this.buttonWidthFactor,
      required this.buttonRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 30,
        width: MediaQuery.of(context).size.width * buttonWidthFactor,
        child: OutlinedButton(
          onPressed: buttonAction,
          style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(buttonRadius),
              ),
              minimumSize: Size(117, 37),
              backgroundColor: buttonColor,
              foregroundColor: Colors.white),
          child: Text(
            buttonName,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
          ),
        ));
  }
}
