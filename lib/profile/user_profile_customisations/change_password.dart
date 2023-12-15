import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mindplex/profile/user_profile_controller.dart';
import 'package:mindplex/profile/user_profile_customisations/general_settings.dart';
import 'package:mindplex/services/api_services.dart';

import '../../auth/auth_controller/auth_controller.dart';
import '../../blogs/widgets/gradient_button.dart';
import '../../routes/app_routes.dart';
import '../../utils/colors.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

String? newPasswordError, confirmPasswordError;
bool _oldPasswordVisible = false;
bool _confirmPasswordVisible = false;

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  AuthController authController = Get.put(AuthController());

  ProfileController profileController = Get.put(ProfileController());
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  late FocusNode newPasswordFocusNode, confirmPasswordFocusNode;

  @override
  void initState() {
    _oldPasswordVisible = false;
    _confirmPasswordVisible = false;
    super.initState();

    newPasswordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
    newPasswordFocusNode.addListener(() => setState(() {}));
    confirmPasswordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    newPasswordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();

    super.dispose();
  }

  bool _isUpdating = false;
  ApiService _apiService = ApiService();
  Future<String> changePassword(String password) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(color: Colors.green[900]),
            ));
    setState(() {
      _isUpdating = true;
    });
    try {
      String? message = await _apiService.changePassword(password);
      print(message);
      setState(() {
        _isUpdating = false;
      });
      Navigator.of(context).pop();
      Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
        titleSize: 20,
        messageSize: 17,
        messageColor: Colors.white,
        backgroundColor: Colors.green,
        borderRadius: BorderRadius.circular(8),
        message: "Password Changed",
        duration: const Duration(seconds: 2),
      ).show(context);
      return message;
    } catch (e) {
      setState(() {
        _isUpdating = false;
      });
      print('Error updating user profile: $e');
      return '';
    }
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
                  child: Text("New Password",
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
                          newPasswordController,
                          "New Password",
                          "new",
                          newPasswordFocusNode,
                          confirmPasswordFocusNode,
                          null, () {
                        setState(() {
                          _oldPasswordVisible = !_oldPasswordVisible;
                        });
                      }),
                      newPasswordError != null && isSaved
                          ? errorMessage(newPasswordError.toString())
                          : Container(),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(top: 20),
                        child: Text("Confirm Password",
                            style: textTheme.displayMedium?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.amber)),
                      ),
                      _container(
                          context,
                          confirmPasswordController,
                          "Confirm Password",
                          "confirm",
                          confirmPasswordFocusNode,
                          null,
                          newPasswordController.text, () {
                        setState(() {
                          _confirmPasswordVisible = !_confirmPasswordVisible;
                        });
                      }),
                      confirmPasswordError != null && isSaved
                          ? errorMessage(confirmPasswordError.toString())
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
                      newPasswordController.text = "";
                      confirmPasswordController.text = "";
                    }, Colors.blueAccent, false),
                    buildButton("Save", (() async {
                      isSaved = false;
                      final isValidForm = _formKey.currentState!.validate();
                      setState(() {
                        isSaved = true;
                      });
                      if (isValidForm) {
                        changePassword(confirmPasswordController.text);
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
              type == "new" ? !_oldPasswordVisible : !_confirmPasswordVisible,
          style: type == "new"
              ? _oldPasswordVisible
                  ? textTheme.displayMedium?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white)
                  : TextStyle(color: Colors.amber, fontSize: 30)
              : //font size to be changed later on
              _confirmPasswordVisible
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
            contentPadding: type == "new"
                ? _oldPasswordVisible
                    ? EdgeInsets.only(left: 10, top: 10, bottom: 10)
                    : EdgeInsets.only(left: 5, bottom: 5)
                : _confirmPasswordVisible
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
                type == "new"
                    ? _oldPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off
                    : _confirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                color: focus.hasFocus ? Colors.blue : Colors.amber,
                size: 30,
              ), //
            ),
          ),
          onFieldSubmitted: ((value) {
            if (type == "new") {
              FocusScope.of(context).requestFocus(focusNext);
            } else {
              FocusScope.of(context).unfocus();
            }
          }),
          validator: ((value) {
            if (type == "new") {
              if (value != null && value.length < 8) {
                newPasswordError = "Must be at least 8 characters";
                return newPasswordError;
              } else if (!value!.contains(RegExp(r'[a-z]'))) {
                newPasswordError = "Must have at least 1 lower case alphabet";
                return newPasswordError;
              } else if (!value!.contains(RegExp(r'[A-Z]'))) {
                newPasswordError = "Must have at least 1 upper case alphabet";
                return newPasswordError;
              } else if (!value!.contains(RegExp(r'[0-9]'))) {
                newPasswordError = "Must have at least 1 number";
                return newPasswordError;
              } else {
                newPasswordError = null;
                return null;
              }
            } else if (type == "confirm") {
              if (value != null && value.length < 8) {
                confirmPasswordError = "Must be at least 8 characters";
                return confirmPasswordError;
              } else if (value != confirmPassword) {
                confirmPasswordError = "Passwords do not match";
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
