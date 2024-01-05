import 'package:flutter/material.dart';

class GuestUser extends StatelessWidget {
  const GuestUser({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 190,
          child: Center(
            child: Text(
              "Hello Guest , 👋",
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 30,
                  color: Colors.white),
            ),
          ),
        ),
        Divider(
          thickness: 1.4,
          color: Colors.white,
        )
      ],
    );
  }
}
