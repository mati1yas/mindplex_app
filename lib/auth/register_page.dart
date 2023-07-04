import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final VoidCallback changePage;
  const RegisterPage({super.key, required this.changePage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('This is registration Page'),
          ]),
        ),
      ),
    );
  }
}
