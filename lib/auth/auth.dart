import 'package:flutter/material.dart';

import '../main.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) =>
      // isLogin
      // ? LoginPage(onClickedLogIn: toggle)
      // : RegisterPage(
      //     onClickedRegister: toggle,
      //   );
      const MyHomePage(title: "Mindplex");

  void toggle() => setState(() => isLogin = !isLogin);
}
