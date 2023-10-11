import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mindplex_app/profile/user_profile_controller.dart';

import '../auth/auth_controller/auth_controller.dart';
import '../blogs/widgets/gradient_button.dart';
import '../routes/app_routes.dart';
import '../utils/colors.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

String? passwordError, confirmPasswordError;
bool _passwordVisible = false;
bool _confirmPasswordVisible = false;

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  AuthController authController = Get.put(AuthController());

  ProfileController profileController = Get.put(ProfileController());
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  late FocusNode passwordFocusNode, confirmPasswordFocusNode;

  @override
  void initState() {
    _passwordVisible = false;
    _confirmPasswordVisible = false;
    super.initState();

    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
    passwordFocusNode.addListener(() => setState(() {}));
    confirmPasswordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();

    super.dispose();
  }

  bool isSaved = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    IconThemeData icon = Theme.of(context).iconTheme;
    return Scaffold(
        backgroundColor: mainBackgroundColor,
        body:SingleChildScrollView(
        child:Container(
        margin: const EdgeInsets.only(left: 15, right: 15),
    child: Column(
    children: [
    Container(
    margin: const EdgeInsets.only(top: 25, bottom: 15),
    child: Text("Create new password", style: textTheme.displayLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.white)),
    ),
    Container(
    margin: const EdgeInsets.symmetric(horizontal: 5),
    child: Text("Your new password must be different from the old password",
    textAlign: TextAlign.center,
    style: textTheme.displayMedium?.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
        color: Colors.white
    )),
    ),
    Container(
    alignment: Alignment.topLeft,
    margin: const EdgeInsets.only(top: 20),
    child: Text("Password", style: textTheme.displayMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.amber)),
    ),
    Form(
    key: _formKey,
    child: Column(
    children: [
    _container(context, passwordController, "Password", "password", passwordFocusNode, confirmPasswordFocusNode, null, () {
    setState(() {
    _passwordVisible = !_passwordVisible;
    });
    }),
    passwordError != null && isSaved ? errorMessage(passwordError.toString()) : Container(),
    const SizedBox(
    height: 20,
    ),
    Container(
    alignment: Alignment.topLeft,
    margin: const EdgeInsets.only(top: 20),
    child: Text("Confirm Password", style: textTheme.displayMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.amber)),
    ),
    _container(
    context, confirmPasswordController, "Confirm Password", "confirm", confirmPasswordFocusNode, null, passwordController.text,
    () {
    setState(() {
    _confirmPasswordVisible = !_confirmPasswordVisible;
    });
    }),
    confirmPasswordError != null && isSaved ? errorMessage(confirmPasswordError.toString()) : Container(),
    const SizedBox(
    height: 30,
    ),
    ],
    ),
    ),
    GradientBtn(
    onPressed: (() {
    final isValidForm = _formKey.currentState!.validate();
    setState(() {
    isSaved = true;
    });
    if (isValidForm) {
      print(confirmPasswordController.text);
    }
    }),
    btnName: 'Reset Password',
    defaultBtn: true,
    isPcked: false,
    width: 280,
    height: 52,
    ),
    ],
    ),
    ),),);
  }
}
Widget _container(BuildContext context, TextEditingController controller, String? hint, String? type, FocusNode focus, FocusNode? focusNext,
    String? confirmPassword, VoidCallback onTap) {
  TextTheme textTheme = Theme.of(context).textTheme;
  Color secondbackgroundColor = Theme.of(context).cardColor;
  return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: secondbackgroundColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(1, 1),
            color: const Color.fromARGB(54, 188, 187, 187),
          )
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: TextFormField(
          focusNode: focus,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller,
          obscureText: type == "password" ? !_passwordVisible : !_confirmPasswordVisible,
          style: textTheme.displayMedium?.copyWith(fontSize: 15, fontWeight: FontWeight.w400),
          textAlignVertical: TextAlignVertical.center,
          cursorColor: Colors.blue,
          decoration: InputDecoration(
            filled: true,
            fillColor: secondbackgroundColor,
            hintStyle: TextStyle(color: Colors.grey[400]),
            hintText: hint,
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(15.0),
            ),
            errorStyle: const TextStyle(fontSize: 0.01),
            contentPadding: const EdgeInsets.only(left: 25, top: 10, bottom: 10),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(15.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(15.0),
            ),
            border: InputBorder.none,
            suffixIcon: IconButton(
              onPressed: onTap,
              icon: Icon(
                type == "password"
                    ? _passwordVisible
                    ? Icons.visibility
                    : Icons.visibility_off
                    : _confirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: focus.hasFocus ? Colors.blue : const Color.fromARGB(255, 172, 172, 171),
              ), //
            ),
          ),
          onFieldSubmitted: ((value) {
            if (type == "password") {
              FocusScope.of(context).requestFocus(focusNext);
            } else {
              FocusScope.of(context).unfocus();
            }
          }),
          validator: ((value) {
            if (type == "password") {
              if (value != null && value.length < 8) {
                passwordError = "Must be at least 8 characters";
                return passwordError;
              } else {
                passwordError = null;
                return null;
              }
            } else if (type == "confirm") {
              if (value != confirmPassword) {
                confirmPasswordError = "Both passwords must match";
                return confirmPasswordError;
              } else {
                confirmPasswordError = null;
                return null;
              }
            } else {
              return null;
            }
          }),
        ),
      ));
}
Widget errorMessage(String? error) {
  return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(top: 5, left: 2),
      child: Text(
        error.toString(),
        style: const TextStyle(color: Colors.red),
      ));
}

