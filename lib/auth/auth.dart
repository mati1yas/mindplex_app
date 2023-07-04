import 'package:flutter/material.dart';
import 'package:mindplex_app/auth/login_page.dart';
import 'package:mindplex_app/auth/register_page.dart';

import '../main.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginPage(changePage: toggle)
      : RegisterPage(
          changePage: toggle,
        );

  void toggle() => setState(() => isLogin = !isLogin);
}
