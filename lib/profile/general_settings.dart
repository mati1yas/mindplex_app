import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:mindplex_app/profile/user_profile_controller.dart';
import 'package:mindplex_app/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth_controller/auth_controller.dart';
import '../utils/box_icons.dart';
import '../utils/colors.dart';
import '../utils/constatns.dart';

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({Key? key}) : super(key: key);

  @override
  State<GeneralSettings> createState() => _GeneralSettingsState();
}
final _formKey = GlobalKey<FormState>();
String? user_name, user_email, user_display_name;
String? userNameError, userEmailError, userDisplayNameError;

class _GeneralSettingsState extends State<GeneralSettings> {
  String? title;
  bool isSaved = false;
  bool isValueSet = false;
  AuthController authController = Get.put(AuthController());

  ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final userName = profileController.authenticatedUser.value.username ?? " ";
    final email = profileController.authenticatedUser.value.userEmail??" ";
    final userDisplayName = profileController.authenticatedUser.value.userDisplayName??" ";
    user_name = profileController.authenticatedUser.value.username ?? " ";
    user_email = profileController.authenticatedUser.value.userEmail ?? " ";
    user_display_name = profileController.authenticatedUser.value.userDisplayName ?? " ";


    return Scaffold(
      backgroundColor: mainBackgroundColor,
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            margin: const EdgeInsets.only(top: 40, left: 5, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Get.toNamed(AppRoutes.settingsPage);
                  },
                ),
                Text('General Settings', textAlign: TextAlign.end, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white)),
                const SizedBox(width: 35)
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(children: [
                  const SizedBox(height: 10),
                  _container(context, false, null, userName, TextInputType.name, Icons.verified_user, 20, userName, "uName", (() {})),
                  userNameError != null && isSaved ? errorMessage(userNameError.toString()) : Container(),
                  _container(context, false, null, email, TextInputType.name, BoxIcons.bx_user, 20, email, "uEmail", (() {})),
                  userEmailError != null && isSaved ? errorMessage(userEmailError.toString()) : Container(),
                  _container(
                    context,
                    false,
                    null,
                    userDisplayName,
                    TextInputType.name,
                    BoxIcons.bx_briefcase,
                    21,
                    userDisplayName,
                    "uDisplayName",
                    (() {}),
                  ),
                  userDisplayNameError != null && isSaved ? errorMessage(userDisplayNameError.toString()) : Container(),
                ])),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: buildButton("Save", (() async {
                    isSaved = false;
                    final isValidForm = _formKey.currentState!.validate();
                    setState(() {
                      isSaved = true;
                    });
                    if (isValidForm) {
                      print(user_name! + " " + user_display_name!+" " + user_email!);
                    }
                  }), const Color(0xFFF400D7), const Color(0xFFFF00D7)),
                ),
                buildButton("Delete Account", () async {
                  print("account deleted");
                }, const Color.fromARGB(255, 255, 0, 0), const Color.fromARGB(255, 253, 47, 47))
              ],
            ),
          ),

        ]),
      ),
    );
  }
  String? hintText(String? inputType) {
    if (inputType == "uName") {
      return "User Name";
    } else if (inputType == "uEmail") {
      return "Email Address";
    }else if (inputType == "uDisplayName") {
      return "Mindplex Handle";
    }
    return null;
  }

  Widget _container(BuildContext context, bool readOnly, TextEditingController? controller, String? initialValue, TextInputType? inputType,
      IconData icon, double iconSize, String? value, String? type, VoidCallback onTap) {
    TextTheme textTheme = Theme.of(context).textTheme;
    Color secondbackgroundColor = Theme.of(context).cardColor;
    IconThemeData icontheme = Theme.of(context).iconTheme;

    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              hintText(type)??" ",
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.w800,
                fontSize: 20
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    readOnly: readOnly,
                    controller: controller,
                    initialValue: initialValue,
                    keyboardType: inputType,
                    style: textTheme.headline2?.copyWith(fontSize: 15, fontWeight: FontWeight.w400),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: secondbackgroundColor,
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        hintText: hintText(type),
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
                        border: InputBorder.none,
                        suffixIcon: Icon(
                          icon,
                          size: iconSize,
                          color: const Color.fromARGB(255, 172, 172, 171),
                        )),
                    onTap: onTap,
                    onChanged: (value) {
                      if (type == "uName") {
                        user_name = value;
                      } else if (type == "uEmail") {
                        user_email = value;
                      } else if (type == "uDisplayName") {
                        user_display_name = value;
                      }
                    },
                    validator: ((value) {
                      if (type == "uName") {
                        if (value != null && value.length < 3) {
                          userNameError = "Please enter your user name (Minimum of 3 characters)";
                          return userNameError;
                        } else {
                          userNameError = null;
                          return null;
                        }
                      }
                      else if (type == "uEmail") {
                        final emailRegex = RegExp(
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                        if (value!.isEmpty) {
                          userEmailError = "Please enter a valid email address (ex. abc@gmail.com)";
                          return userEmailError;
                        } else if (emailRegex.hasMatch(value) == false) {
                          userEmailError = "Please enter a valid email address (ex. abc@gmail.com)";
                          return userEmailError;
                        }
                        userEmailError = null;
                        return null;
                      } else if (type == "uDisplayName") {
                        if (value != null && value.length < 3) {
                          userDisplayNameError = "Please enter your mindplex handle (Minimum of 3 characters)";
                          return userDisplayNameError;
                        } else {
                          userDisplayNameError = null;
                          return null;
                        }
                      }
                      return null;
                    })))),
      ],
    );
  }
}
Widget buildButton(String label, VoidCallback onTap, Color color1, Color color2) {
  return SizedBox(
    key: UniqueKey(),
    width: 150,
    height: 50,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color1, color1, color1, color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    ),
  );
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

snackbar(Text title, Text message) {
  return Get.snackbar("", "",
      snackStyle: SnackStyle.FLOATING,
      snackPosition: SnackPosition.BOTTOM,
      borderWidth: 2,
      dismissDirection: DismissDirection.horizontal,
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.blue,
      titleText: title,
      messageText: message,
      margin: const EdgeInsets.only(top: 12, left: 15, right: 15, bottom: 15));
}
