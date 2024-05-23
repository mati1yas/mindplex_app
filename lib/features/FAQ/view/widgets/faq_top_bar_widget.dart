import 'package:flutter/material.dart';

class FAQTopBarWidget extends StatelessWidget {
  const FAQTopBarWidget({
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 8,
        ),
        Container(
            child: BackButton(
          color: Colors.white70,
        )),
        SizedBox(
          width: screenWidth * 0.3,
        ),
        Text(
          "FAQs",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        Spacer()
      ],
    );
  }
}
