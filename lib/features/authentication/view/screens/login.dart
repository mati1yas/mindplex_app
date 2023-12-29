import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(252, 5, 34, 40),
      body: Container(
        height: double.maxFinite,
        child: Material(
          color: Color.fromARGB(252, 5, 34, 40),
          child: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(children: [
                      Image.asset('assets/images/logo_with_name.png'),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Join Mindplex",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ]),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: 320,
                    padding: EdgeInsets.only(
                        left: 30, right: 30, top: 15, bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade600,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Text(
                      "Create Account",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "OR",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 17),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 320,
                    padding: EdgeInsets.only(
                        left: 30, right: 30, top: 15, bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Image.asset("assets/images/google_logo.png"),
                        SizedBox(
                          width: 5,
                        ),
                        Center(
                            child: Text(
                          "Register with Google",
                          style: TextStyle(fontSize: 20),
                        )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 320,
                    padding: EdgeInsets.only(
                        left: 30, right: 30, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/linkedin_logo2.PNG",
                          width: 35,
                          height: 35,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Center(
                            child: Text(
                          "Register with linkedin",
                          style: TextStyle(fontSize: 20),
                        )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 320,
                    padding: EdgeInsets.only(
                        left: 20, right: 30, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/twiter_logo.PNG",
                          width: 35,
                          height: 35,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                            child: Text(
                          "Register with Twiter",
                          style: TextStyle(fontSize: 20),
                        )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  Container(
                    width: 320,
                    padding: EdgeInsets.only(
                        left: 30, right: 30, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/facebook_logo.PNG",
                          width: 30,
                          height: 30,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                            child: Text(
                          "Register with Facebook",
                          style: TextStyle(fontSize: 20),
                        )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
