import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';
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

String? newPasswordError, confirmPasswordError;

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  AuthController authController = Get.put(AuthController());

  ProfileController profileController = Get.put(ProfileController());
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
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

  SettingsController settingsController = Get.find<SettingsController>();

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
                          settingsController.oldPasswordVisible.value = !settingsController.oldPasswordVisible.value;
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
                      passwordInput(
                          context,
                          confirmPasswordController,
                          "Confirm Password",
                          "confirm",
                          confirmPasswordFocusNode,
                          null,
                          newPasswordController.text, () {
                        setState(() {
                          settingsController.confirmPasswordVisible.value = !settingsController.confirmPasswordVisible.value;
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

Widget errorMessage(String? error) {
  return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(top: 5, left: 2),
      child: Text(
        error.toString(),
        style: const TextStyle(color: Colors.red),
      ));
}
