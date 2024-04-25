import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';
import 'package:mindplex/routes/app_routes.dart';
import 'package:mindplex/utils/awesome_snackbar.dart';
import 'package:mindplex/utils/network/connection-info.dart';
import 'package:mindplex/utils/snackbar_constants.dart';

import '../../controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback changePage;

  const RegisterPage({super.key, required this.changePage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? fnameError, lnameError, emailError, passwordError;
  bool isSaved = false;
  bool isPressed = true;
  bool checkPolicy = false;
  final formkey = GlobalKey<FormState>();
  late FocusNode fnameFocusNode,
      lnameFocusNode,
      emailFocusNode,
      passwordFocusNode;

  @override
  void initState() {
    super.initState();

    fnameFocusNode = FocusNode();
    lnameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    fnameFocusNode.addListener(() => setState(() {}));
    lnameFocusNode.addListener(() => setState(() {}));
    emailFocusNode.addListener(() => setState(() {}));
    passwordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    fnameFocusNode.dispose();
    lnameFocusNode = FocusNode();
    emailFocusNode.dispose();
    passwordFocusNode = FocusNode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderSide: Divider.createBorderSide(context),
        borderRadius: BorderRadius.circular(10));
    // final themeProvider = Provider.of<ThemeProvider>(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    Color secondbackgroundColor = Theme.of(context).cardColor;
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Material(
        color: Color.fromARGB(252, 5, 34, 40),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Let's get you set up",
                      style: textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Create an account",
                      style: textTheme.displayMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Form(
                      key: formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ThemeData().colorScheme.copyWith(
                                  primary: Colors.blue,
                                  secondary: Colors.white),
                            ),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: secondbackgroundColor,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    offset: const Offset(1, 1),
                                    color:
                                        const Color.fromARGB(54, 188, 187, 187),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: TextFormField(
                                  controller: firstnameController,
                                  focusNode: fnameFocusNode,
                                  cursorColor:
                                      Color.fromARGB(224, 14, 187, 158),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.account_circle_outlined,
                                      color: fnameFocusNode.hasFocus
                                          ? Color.fromARGB(224, 14, 187, 158)
                                          : Colors.grey,
                                    ),
                                    hintText: "First name",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                    fillColor: secondbackgroundColor,
                                    filled: true,
                                    border: inputBorder,
                                    enabledBorder: inputBorder,
                                    errorStyle: const TextStyle(fontSize: 0.01),
                                    errorBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              224, 14, 187, 158)),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  style: textTheme.displayMedium?.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value != null && value.isEmpty) {
                                      fnameError = "Enter a first name";
                                      return fnameError;
                                    } else {
                                      fnameError = null;
                                      return null;
                                    }
                                  }),
                            ),
                          ),
                          // fnameError != null && isSaved
                          //     ? errorMessage(fnameError.toString())
                          //     : Container(),
                          const SizedBox(
                            height: 20,
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ThemeData().colorScheme.copyWith(
                                    primary: Colors.blue,
                                  ),
                            ),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: secondbackgroundColor,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    offset: const Offset(1, 1),
                                    color:
                                        const Color.fromARGB(54, 188, 187, 187),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: TextFormField(
                                  controller: lastnameController,
                                  focusNode: lnameFocusNode,
                                  cursorColor:
                                      Color.fromARGB(224, 14, 187, 158),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.account_circle_outlined,
                                      color: lnameFocusNode.hasFocus
                                          ? Color.fromARGB(224, 14, 187, 158)
                                          : Colors.grey,
                                    ),
                                    hintText: "Last name",
                                    hintStyle: TextStyle(
                                        fontSize: 14, color: Colors.grey[400]),
                                    fillColor: secondbackgroundColor,
                                    filled: true,
                                    border: inputBorder,
                                    enabledBorder: inputBorder,
                                    errorStyle: const TextStyle(fontSize: 0.01),
                                    errorBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              224, 14, 187, 158)),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  style: textTheme.displayMedium?.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value != null && value.isEmpty) {
                                      lnameError = "Enter a last name";
                                      return lnameError;
                                    } else {
                                      lnameError = null;
                                      return null;
                                    }
                                  }),
                            ),
                          ),
                          // lnameError != null && isSaved
                          //     ? errorMessage(lnameError.toString())
                          //     : Container(),
                          const SizedBox(
                            height: 20,
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ThemeData().colorScheme.copyWith(
                                    primary: Colors.blue,
                                  ),
                            ),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: secondbackgroundColor,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    offset: const Offset(1, 1),
                                    color:
                                        const Color.fromARGB(54, 188, 187, 187),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: TextFormField(
                                  controller: emailController,
                                  focusNode: emailFocusNode,
                                  cursorColor:
                                      Color.fromARGB(224, 14, 187, 158),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.mail_outline,
                                      color: emailFocusNode.hasFocus
                                          ? Color.fromARGB(224, 14, 187, 158)
                                          : Colors.grey,
                                    ),
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                        fontSize: 14, color: Colors.grey[400]),
                                    fillColor: secondbackgroundColor,
                                    filled: true,
                                    border: inputBorder,
                                    enabledBorder: inputBorder,
                                    errorStyle: const TextStyle(fontSize: 0.01),
                                    errorBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              224, 14, 187, 158)),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  style: textTheme.displayMedium?.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value != null && !value.contains('@') ||
                                        !value!.contains('.')) {
                                      emailError = "Enter a valid Email";
                                      return emailError;
                                    } else {
                                      emailError = null;
                                      return null;
                                    }
                                  }),
                            ),
                          ),
                          // emailError != null && isSaved
                          //     ? errorMessage(emailError.toString())
                          //     : Container(),
                          const SizedBox(
                            height: 20,
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ThemeData().colorScheme.copyWith(
                                    primary: Colors.blue,
                                  ),
                            ),
                            child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: secondbackgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 10,
                                      offset: const Offset(1, 1),
                                      color: const Color.fromARGB(
                                          54, 188, 187, 187),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: TextFormField(
                                    controller: passwordController,
                                    focusNode: passwordFocusNode,
                                    cursorColor:
                                        Color.fromARGB(224, 14, 187, 158),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock_outline,
                                        color: passwordFocusNode.hasFocus
                                            ? Color.fromARGB(224, 14, 187, 158)
                                            : Colors.grey,
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isPressed = !isPressed;
                                          });
                                        },
                                        icon: isPressed
                                            ? Icon(
                                                Icons.visibility_off_outlined,
                                                color:
                                                    passwordFocusNode.hasFocus
                                                        ? Color.fromARGB(
                                                            224, 14, 187, 158)
                                                        : Colors.grey)
                                            : Icon(Icons.visibility_outlined,
                                                color: passwordFocusNode
                                                        .hasFocus
                                                    ? Color.fromARGB(
                                                        224, 14, 187, 158)
                                                    : Colors.grey),
                                      ),
                                      hintText: "Password",
                                      hintStyle: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[400]),
                                      fillColor: secondbackgroundColor,
                                      filled: true,
                                      border: inputBorder,
                                      enabledBorder: inputBorder,
                                      errorStyle:
                                          const TextStyle(fontSize: 0.01),
                                      errorBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: Colors.red),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color.fromARGB(
                                                224, 14, 187, 158)),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    style: textTheme.displayMedium?.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                    keyboardType: TextInputType.text,
                                    obscureText: isPressed,
                                    textInputAction: TextInputAction.done,
                                    validator: (value) {
                                      if (value != null && value.isEmpty) {
                                        passwordError = 'Enter a password';
                                        return passwordError;
                                      } else if (value!.length < 8) {
                                        passwordError =
                                            'password length can\'t be lessthan 8';
                                        return passwordError;
                                      } else {
                                        passwordError = null;
                                        return null;
                                      }
                                    })),
                          ),
                          // passwordError != null && isSaved
                          //     ? errorMessage(passwordError.toString())
                          //     : Container(),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Theme(
                                data: ThemeData(
                                    unselectedWidgetColor: Colors.grey),
                                child: Checkbox(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    value: checkPolicy,
                                    onChanged: (onChanged) {
                                      setState(() {
                                        checkPolicy = !checkPolicy;
                                      });
                                    }),
                              ),
                              Expanded(
                                child: Text(
                                  "By continuing you accept our Privacy Policy and Terms of Use",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: textTheme.titleLarge?.copyWith(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: register,
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        fixedSize: Size(260, 50),
                        backgroundColor: Color.fromARGB(224, 14, 187, 158)),
                    child: Text('Register'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                            color: Colors.grey,
                            height: 1,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Or",
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: 17),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            color: Colors.grey,
                            height: 1,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: signin,
                          child: Container(
                              width: 50,
                              height: 50,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      width: 2,
                                      color: const Color.fromARGB(
                                          208, 178, 178, 178))),
                              child:
                                  Image.asset("assets/images/google_logo.png")),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Already have an account?",
                          style: textTheme.displayMedium?.copyWith(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w400)),
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.changePage,
                          text: " Login",
                          style: const TextStyle(
                              color: Colors.pink,
                              fontSize: 17,
                              fontWeight: FontWeight.w700))
                    ]),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future signin() async {
    ConnectionInfoImpl connectionChecker = Get.find();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn.disconnect();
    AuthController authController = Get.put(AuthController());

    try {
      if (!await connectionChecker.isConnected) {
        throw NetworkException("");
      }
      final user = await googleSignIn.signIn();

      if (user != null) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(
                  child: CircularProgressIndicator(color: Colors.green[900]),
                ));
        String? name = "";

        if (user!.displayName != null) {
          name = user.displayName;
        }

        await authController.loginUserWithGoogle(
            email: user.email,
            firstName: name!,
            lastName: name,
            googleId: user.id);

        if (authController.isAuthenticated.value) {
          Navigator.pop(context);

          Get.offAllNamed(AppRoutes.landingPage);
          ProfileController profileController = Get.put(ProfileController());
          await profileController.getAuthenticatedUser();
        }
      }
    } catch (error) {
      if (error is NetworkException) {
        showSnackBar(
            context: context,
            title: "Oops ! ",
            message: SnackBarConstantMessage.noInternetConnection,
            type: "failure");
      } else {
        showSnackBar(
            context: context,
            title: "Oops !",
            message: "Sign-in Failed Please try again.",
            type: "failure");
      }
    }
  }

  Future register() async {
    FocusScope.of(context).unfocus();
    isSaved = false;
    final form = formkey.currentState!;
    setState(() {
      isSaved = true;
    });
    if (form.validate()) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
                child: CircularProgressIndicator(color: Colors.green[900]),
              ));

      AuthController authController = Get.put(AuthController());

      await authController.register(
          email: emailController.text,
          firstName: firstnameController.text,
          lastName: lastnameController.text,
          password: passwordController.text);
      Navigator.pop(context);
      if (authController.isRegistered.isTrue) {
        Get.offAllNamed(AppRoutes.authPage);
        if (mounted) {
          Flushbar(
            flushbarPosition: FlushbarPosition.BOTTOM,
            margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
            titleSize: 20,
            messageSize: 17,
            backgroundColor: Colors.green,
            borderRadius: BorderRadius.circular(8),
            message: authController.statusMessage.toString(),
            duration: const Duration(seconds: 5),
          ).show(context);
        }
      } else {
        if (mounted) {
          Flushbar(
            flushbarPosition: FlushbarPosition.BOTTOM,
            margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
            titleSize: 20,
            messageSize: 17,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(8),
            message: authController.statusMessage.toString(),
            duration: const Duration(seconds: 5),
          ).show(context);
        }
      }
    }
  }
}
