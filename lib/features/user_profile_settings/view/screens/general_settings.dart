import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';
import 'package:mindplex/features/user_profile_settings/controllers/settings_controller.dart';
import 'package:mindplex/routes/app_routes.dart';

import '../../../../utils/colors.dart';
import '../../../authentication/controllers/auth_controller.dart';
import '../widgets/button_widget.dart';
import '../widgets/error_message_widget.dart';
import '../widgets/input_box_widget.dart';

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({Key? key}) : super(key: key);

  @override
  State<GeneralSettings> createState() => _GeneralSettingsState();
}

final _formKey = GlobalKey<FormState>();
String? userNameError, userEmailError, userDisplayNameError;

class _GeneralSettingsState extends State<GeneralSettings> {
  @override
  void initState() {
    super.initState();
    profileController.getAuthenticatedUser();
    userNameController.text =
        profileController.authenticatedUser.value.username ?? "";
    emailController.text =
        profileController.authenticatedUser.value.userEmail ?? "";
  }

  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  AuthController authController = Get.put(AuthController());
  ProfileController profileController = Get.put(ProfileController());
  SettingsController settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(children: [
                  const SizedBox(height: 10),
                  inputBoxWithLabel(context, false, userNameController,
                      TextInputType.name, "Username"),
                  Obx(
                    () => settingsController.usernameError.value != "" &&
                            settingsController.isSaved.value
                        ? errorMessage(settingsController.usernameError.value)
                        : Container(),
                  ),
                  inputBoxWithLabel(context, false, emailController,
                      TextInputType.name, "Email"),
                  Obx(
                    () => settingsController.emailError.value != "" &&
                            settingsController.isSaved.value
                        ? errorMessage(settingsController.emailError.value)
                        : Container(),
                  ),
                  inputBoxWithLabel(context, true, userNameController,
                      TextInputType.name, "Mindplex Handle"),
                ])),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Row(
              children: [
                buildButton("Cancel", () async {
                  print("account deleted");
                }, Colors.blueAccent, false),
                Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: buildButton("Save", (() async {
                      settingsController.isSaved.value = false;
                      final isValidForm = _formKey.currentState!.validate();
                      settingsController.isSaved.value = true;
                      if (isValidForm) {}
                    }), Colors.blueAccent.shade200, true))
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
