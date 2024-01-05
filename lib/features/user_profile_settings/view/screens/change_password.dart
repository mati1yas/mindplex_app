import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';
import 'package:mindplex/features/user_profile_settings/controllers/change_password_controller.dart';
import 'package:mindplex/features/user_profile_settings/view/widgets/password_input_widget.dart';
import 'package:mindplex/services/api_services.dart';

import '../../../../utils/colors.dart';
import '../../../authentication/controllers/auth_controller.dart';
import '../../controllers/settings_controller.dart';
import 'general_settings.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  AuthController authController = Get.put(AuthController());

  ProfileController profileController = Get.put(ProfileController());
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  late FocusNode newPasswordFocusNode, confirmPasswordFocusNode;

  @override
  void initState() {

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
  Future<void> changePassword(String password) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(color: Colors.green[900]),
            ));
    passwordController.saveNewPassword(password);
  }

  final _formKey = GlobalKey<FormState>();

  PasswordController passwordController = Get.put(PasswordController());

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
                      passwordInput(
                          context,
                          newPasswordController,
                          "New Password",
                          "new",
                          newPasswordFocusNode,
                          confirmPasswordFocusNode,
                          null, () {
                        setState(() {
                          passwordController.oldPasswordVisible.value = !passwordController.oldPasswordVisible.value;
                        });
                      }),
                      passwordController.newPasswordError != null && passwordController.isSaved.value
                          ? errorMessage( passwordController.newPasswordError?.value)
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
                      passwordInput(
                          context,
                          confirmPasswordController,
                          "Confirm Password",
                          "confirm",
                          confirmPasswordFocusNode,
                          null,
                          newPasswordController.text, () {
                        setState(() {
                          passwordController.confirmPasswordVisible.value = !passwordController.confirmPasswordVisible.value;
                        });
                      }),
                      passwordController.confirmPasswordError != null && passwordController.isSaved.value
                          ? errorMessage(passwordController.confirmPasswordError?.value)
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
                      newPasswordFocusNode.unfocus();
                      confirmPasswordFocusNode.unfocus();
                      newPasswordController.text = "";
                      confirmPasswordController.text = "";
                    }, Colors.blueAccent, false),
                    buildButton("Save", (() async {
                      newPasswordFocusNode.unfocus();
                      confirmPasswordFocusNode.unfocus();
                      passwordController.setIsSaved(false);
                      final isValidForm = _formKey.currentState!.validate();
                      setState(() {
                        passwordController.setIsSaved(true);
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

Widget errorMessage(String? error) {
  return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(top: 5, left: 2),
      child: Text(
        error.toString(),
        style: const TextStyle(color: Colors.red),
      ));
}
