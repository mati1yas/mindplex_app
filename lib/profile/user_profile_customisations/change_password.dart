import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mindplex_app/profile/user_profile_controller.dart';

import '../../auth/auth_controller/auth_controller.dart';
import '../../blogs/widgets/gradient_button.dart';
import '../../routes/app_routes.dart';
import '../../utils/colors.dart';
import 'general_settings.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

String? oldPasswordError, newPasswordError;
bool _oldPasswordVisible = false;
bool _newPasswordVisible = false;

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  AuthController authController = Get.put(AuthController());

  ProfileController profileController = Get.put(ProfileController());
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  late FocusNode oldPasswordFocusNode, newPasswordFocusNode;

  @override
  void initState() {
    _oldPasswordVisible = false;
    _newPasswordVisible = false;
    super.initState();

    oldPasswordFocusNode = FocusNode();
    newPasswordFocusNode = FocusNode();
    oldPasswordFocusNode.addListener(() => setState(() {}));
    newPasswordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    oldPasswordFocusNode.dispose();
    newPasswordFocusNode.dispose();

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
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 20),
                  child: Text("Old Password",
                      style: textTheme.displayMedium?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.amber)),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _container(
                          context,
                          oldPasswordController,
                          "Old Password",
                          "password",
                          oldPasswordFocusNode,
                          newPasswordFocusNode,
                          null, () {
                        setState(() {
                          _oldPasswordVisible = !_oldPasswordVisible;
                        });
                      }),
                      oldPasswordError != null && isSaved
                          ? errorMessage(oldPasswordError.toString())
                          : Container(),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(top: 20),
                        child: Text("New Password",
                            style: textTheme.displayMedium?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.amber)),
                      ),
                      _container(context, newPasswordController, "New Password",
                          "new", newPasswordFocusNode, null, null, () {
                        setState(() {
                          _newPasswordVisible = !_newPasswordVisible;
                        });
                      }),
                      newPasswordError != null && isSaved
                          ? errorMessage(newPasswordError.toString())
                          : Container(),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildButton("Cancel", () async {
                      print("account deleted");
                    }, Colors.blueAccent, false),
                    buildButton("Save", (() async {
                      isSaved = false;
                      final isValidForm = _formKey.currentState!.validate();
                      setState(() {
                        isSaved = true;
                      });
                      if (isValidForm) {
                        print(newPasswordController.text! +
                            " " +
                            oldPasswordController.text!);
                      }
                    }), Colors.blueAccent.shade200, true)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _container(
    BuildContext context,
    TextEditingController controller,
    String? hint,
    String? type,
    FocusNode focus,
    FocusNode? focusNext,
    String? confirmPassword,
    VoidCallback onTap) {
  TextTheme textTheme = Theme.of(context).textTheme;
  Color secondbackgroundColor = Theme.of(context).cardColor;
  return Container(
      height: 48,
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
          obscureText:
              type == "password" ? !_oldPasswordVisible : !_newPasswordVisible,
          style: type == "password"
              ? _oldPasswordVisible
                  ? textTheme.displayMedium?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white)
                  : TextStyle(color: Colors.amber, fontSize: 30)
              : //font size to be changed later on
              _newPasswordVisible
                  ? textTheme.displayMedium?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white)
                  : TextStyle(
                      color: Colors.amber,
                      fontSize: 30), //font size to be changed later on
          textAlignVertical: TextAlignVertical.center,
          cursorColor: Colors.blue,
          decoration: InputDecoration(
            filled: true,
            fillColor: mainBackgroundColor,
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(15.0),
            ),
            errorStyle: const TextStyle(fontSize: 0.01),
            contentPadding: type == "password"
                ? _oldPasswordVisible
                    ? EdgeInsets.only(left: 10, top: 10, bottom: 10)
                    : EdgeInsets.only(left: 5, bottom: 5)
                : _newPasswordVisible
                    ? EdgeInsets.only(left: 10, top: 10, bottom: 10)
                    : EdgeInsets.only(left: 5, bottom: 5),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(15.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.amber, width: 2.0),
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
                    ? _oldPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off
                    : _newPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                color: focus.hasFocus ? Colors.blue : Colors.amber,
                size: 30,
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
                oldPasswordError = "Must be at least 8 characters";
                return oldPasswordError;
              } else {
                oldPasswordError = null;
                return null;
              }
            } else if (type == "new") {
              if (value != null && value.length < 8) {
                newPasswordError = "Must be at least 8 characters";
                return newPasswordError;
              } else {
                newPasswordError = null;
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
