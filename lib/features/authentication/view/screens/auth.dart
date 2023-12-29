import 'package:flutter/material.dart';
import 'package:mindplex/features/authentication/view/screens/login_page.dart';
import 'package:mindplex/features/authentication/view/screens/register_page.dart';

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
