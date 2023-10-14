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
    user_email = profileController.authenticatedUser.value.userEmail ?? " ";
    TextEditingController uName = TextEditingController();
    uName.text = userName;

    user_name = uName.text;
    user_display_name = uName.text;


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
                  _container(context, false, uName, null, TextInputType.name, userName, "uName", (() {})),
                  userNameError != null && isSaved ? errorMessage(userNameError.toString()) : Container(),
                  _container(context, false, null, email, TextInputType.name, email, "uEmail", (() {})),
                  userEmailError != null && isSaved ? errorMessage(userEmailError.toString()) : Container(),
                  _container(
                    context,
                    true,
                    uName,
                    null,
                    TextInputType.name,
                    userName,
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
                buildButton("Cancel", () async {
                  print("account deleted");
                }, Colors.blueAccent, false),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: buildButton("Save", (() async {
                    isSaved = false;
                    final isValidForm = _formKey.currentState!.validate();
                    setState(() {
                      isSaved = true;
                    });
                    if (isValidForm) {
                      print(user_name! + " " + user_display_name!+" " + user_email!);
                    }
                  }), Colors.blueAccent.shade200,true)
                )
              ],
            ),
          ),

        ]),
      ),
    );
  }
  String? hintText(String? inputType) {
    if (inputType == "uName") {
      return "Username";
    } else if (inputType == "uEmail") {
      return "Email";
    }else if (inputType == "uDisplayName") {
      return "Mindplex handle";
    }
    return null;
  }

  Widget _container(BuildContext context, bool readOnly, TextEditingController? controller, String? initialValue, TextInputType? inputType
  , String? value, String? type, VoidCallback onTap) {
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
                  fontWeight: FontWeight.w500,
                  fontSize: 20
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
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
                    style: textTheme.headline2?.copyWith(fontSize: 15, fontWeight: FontWeight.w400,color: Colors.white),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: mainBackgroundColor,
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        errorStyle: const TextStyle(fontSize: 0.01),
                        contentPadding: const EdgeInsets.only(left: 25, top: 10, bottom: 10),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber,width: 2.0),borderRadius: BorderRadius.circular(15)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                    ),
                    onTap: onTap,
                    onChanged: (value) {
                      if (type == "uName") {
                        user_name = value;
                        user_display_name = value;
                        controller?.text = value;
                      } else if (type == "uEmail") {
                        user_email = value;
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
Widget buildButton(String label, VoidCallback onTap, Color color1,bool fill) {
  return SizedBox(
    key: UniqueKey(),
    width: 150,
    height: 50,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: fill?BoxDecoration(
          color: color1,
          borderRadius: BorderRadius.circular(10),
        ):BoxDecoration(
          border: Border.all(color: color1),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Center(
          child: Text(
            label,
            style:fill?TextStyle(color:Colors.white, fontSize: 20):TextStyle(color: color1,fontSize: 20),
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

