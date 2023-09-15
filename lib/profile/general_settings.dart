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

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}
final _formKey = GlobalKey<FormState>();
String? firstName, lastName, birthdate, email, occupation, country;
String? fnameError, lnameError, emailError, occupationError;
TextEditingController dateInputController = TextEditingController();

class _EditProfilePageState extends State<EditProfilePage> {
  String? title;
  bool isSaved = false;
  bool isValueSet = false;
  AuthController authController = Get.put(AuthController());

  ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final firstName = profileController.authenticatedUser.value.firstName ?? " ";
    final lastName = profileController.authenticatedUser.value.lastName??" ";
    final userNiceName = profileController.authenticatedUser.value.userNicename??" ";
    final userDisplayName = profileController.authenticatedUser.value.userDisplayName??" ";
    TextTheme textTheme = Theme.of(context).textTheme;
    IconThemeData icon = Theme.of(context).iconTheme;
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
                    Navigator.pop(context);
                  },
                ),
                Text('Edit Profile', textAlign: TextAlign.end, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white)),
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
                  _container(context, false, null, firstName, TextInputType.name, Icons.verified_user, 20, firstName, "fname", (() {})),
                  fnameError != null && isSaved ? errorMessage(fnameError.toString()) : Container(),
                  _container(context, false, null, lastName, TextInputType.name, BoxIcons.bx_user, 20, lastName, "lname", (() {})),
                  lnameError != null && isSaved ? errorMessage(lnameError.toString()) : Container(),
                  _container(context, true, dateInputController, null, TextInputType.none, Icons.cake_outlined, 21, birthdate, "birthDate",
                          () async {
                        var dateFormat = DateFormat('d-MM-yyyy');
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          lastDate: DateTime(2050),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                primaryColor: Colors.blue,
                                dialogBackgroundColor: Colors.white,
                                colorScheme: ColorScheme.light(
                                  primary: Colors.blue, // header background color
                                  onPrimary:Colors.white, // header text color
                                  onSurface:Colors.black, // body text color
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    primary: Colors.blue, // button text color
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (pickedDate != null) {
                          dateInputController.text = dateFormat.format(pickedDate).toString();
                          birthdate = dateFormat.format(pickedDate).toString();
                        }
                      }),
                  // _container(context, false, null, email, TextInputType.emailAddress, Icons.mail_outline, 21, email, "email", (() {})),
                  // emailError != null && isSaved ? errorMessage(emailError.toString()) : Container(),
                  _container(
                    context,
                    false,
                    null,
                    occupation,
                    TextInputType.name,
                    BoxIcons.bx_briefcase,
                    21,
                    occupation,
                    "occupation",
                    (() {}),
                  ),
                  occupationError != null && isSaved ? errorMessage(occupationError.toString()) : Container(),
                ])),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            decoration: BoxDecoration(
              color: Colors.amber,
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
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  textTheme: TextTheme(
                    subtitle1: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromARGB(255, 41, 40, 40).withOpacity(0.9),
                      fontFamily: 'Red Hat Display',
                    ),
                  ),
                ),
                child: Text("dropdown item goes here"),
                // child: DropdownSearch<String>(
                //   popupItemBuilder: (context, item, isSelected) {
                //     return Container(
                //       margin: const EdgeInsets.only(top: 15, bottom: 10, left: 20),
                //       child: Text(
                //         item,
                //         style: textTheme.headline2?.copyWith(
                //           fontSize: 18,
                //           fontWeight: FontWeight.w400,
                //         ),
                //       ),
                //     );
                //   },
                //   scrollbarProps: const ScrollbarProps(thickness: 5, isAlwaysShown: true),
                //   maxHeight: 400,
                //   mode: Mode.DIALOG,
                //   searchFieldProps: TextFieldProps(
                //     style: textTheme.headline2?.copyWith(fontSize: 18, fontWeight: FontWeight.w400),
                //     cursorColor: Colors.blue,
                //     decoration: InputDecoration(
                //       focusedBorder: const UnderlineInputBorder(
                //         borderSide: BorderSide(color: Colors.blue),
                //       ),
                //       hintText: "Search for a country...",
                //       hintStyle: TextStyle(color: Colors.grey[400], fontSize: 18),
                //       contentPadding: const EdgeInsets.only(left: 10),
                //     ),
                //   ),
                //   dropdownButtonProps: const IconButtonProps(
                //     icon: Icon(
                //       Icons.arrow_drop_down,
                //       size: 30,
                //       color: Color.fromARGB(255, 172, 172, 171),
                //     ),
                //   ),
                //   showSearchBox: true,
                //   dropdownSearchDecoration: InputDecoration(
                //     hintText: "Country",
                //     filled: true,
                //     fillColor:Colors.white,
                //     hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15, fontWeight: FontWeight.w400),
                //     contentPadding: const EdgeInsets.only(left: 25, top: 15, bottom: 10),
                //     focusedBorder: OutlineInputBorder(
                //       borderSide: const BorderSide(color: Colors.blue),
                //       borderRadius: BorderRadius.circular(15.0),
                //     ),
                //     border: InputBorder.none,
                //   ),
                //   selectedItem: country,
                //   items: countryList,
                //   onChanged: (value) => country = value,
                //   // selectedItem: "Brazil",
                // ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          buildButton("Save", (() async {
            isSaved = false;
            final isValidForm = _formKey.currentState!.validate();
            setState(() {
              isSaved = true;
            });
            if (isValidForm) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              // String res = await ApiProvider().profilePatch(firstName!, lastName, dateInputController.text, occupation, country);
              // if (res == "200") {
              //   getValue();
              //   snackbar(
              //     Text(
              //       "Profile Updated",
              //       style: textTheme.headline1?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              //     ),
              //     Text(
              //       "Your profile is updated!",
              //       style: textTheme.headline1?.copyWith(fontSize: 18, fontWeight: FontWeight.w400),
              //     ),
              //   );
              // } else {
              //   snackbar(
              //     Text(
              //       "Profile Update Error",
              //       style: textTheme.headline1?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              //     ),
              //     Text(
              //       "Your profile could not be updated, please try again.",
              //       style: textTheme.headline1?.copyWith(fontSize: 18, fontWeight: FontWeight.w400),
              //     ),
              //   );
              // }
              if (kDebugMode) {
                print("valid");
              }
            }
          }), const Color(0xFF0396FF), const Color.fromARGB(255, 110, 195, 255)),
          const SizedBox(height: 30),
          buildButton("Delete Account", () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            // String res = await ApiProvider().profileDelete();
            // if (res == "Profile successfully deleted") {
            //   await prefs.clear();
            //   // Get.toNamed(AppRoute.splashscreen);
            // } else {
            //   snackbar(
            //     const Text(
            //       "Profile Deletion Error",
            //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            //     ),
            //     Text(
            //       "Your profile could not be deleted, please try again.",
            //       style: textTheme.headline1?.copyWith(fontSize: 18, fontWeight: FontWeight.w400),
            //     ),
            //   );
            // }
          }, const Color.fromARGB(255, 255, 0, 0), const Color.fromARGB(255, 253, 47, 47))
        ]),
      ),
    );
  }
  String? hintText(String? inputType) {
    if (inputType == "fname") {
      return "First Name";
    } else if (inputType == "lname") {
      return "Last Name";
    } else if (inputType == "email") {
      return "Email Address";
    } else if (inputType == "occupation") {
      return "Occupation";
    } else if (inputType == "birthDate") {
      return "Birthdate";
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
                      if (type == "fname") {
                        firstName = value;
                      } else if (type == "lname") {
                        lastName = value;
                      } else if (type == "birthdate") {
                        birthdate = value;
                      } else if (type == "email") {
                        email = value;
                      } else if (type == "occupation") {
                        occupation = value;
                      }
                    },
                    validator: ((value) {
                      if (type == "fname") {
                        if (value != null && value.length < 3) {
                          fnameError = "Please enter your first name (Minimum of 3 characters)";
                          return fnameError;
                        } else {
                          fnameError = null;
                          return null;
                        }
                      } else if (type == "lname") {
                        if (value != null && value.length < 3) {
                          lnameError = "Please enter your first name (Minimum of 3 characters)";
                          return lnameError;
                        } else {
                          lnameError = null;
                          return null;
                        }
                      } else if (type == "email") {
                        final emailRegex = RegExp(
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                        if (value!.isEmpty) {
                          emailError = "Please enter a valid email address (ex. abc@gmail.com)";
                          return emailError;
                        } else if (emailRegex.hasMatch(value) == false) {
                          emailError = "Please enter a valid email address (ex. abc@gmail.com)";
                          return emailError;
                        }
                        emailError = null;
                        return null;
                      } else if (type == "occupation") {
                        final ocupationRegex = RegExp(r'^([^0-9]*)$');
                        if (ocupationRegex.hasMatch(value!) == false) {
                          occupationError = "Please enter a valid occupation (ex. Student, Engineer)";
                          return occupationError;
                        } else {
                          occupationError = null;
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
    width: 290,
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
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 18),
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
