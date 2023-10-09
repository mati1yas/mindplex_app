import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mindplex_app/profile/user_profile_controller.dart';
import 'package:mindplex_app/services/local_storage.dart';

import '../auth/auth_controller/auth_controller.dart';
import '../models/user_profile.dart';
import '../routes/app_routes.dart';
import '../services/api_services.dart';
import '../utils/box_icons.dart';
import '../utils/colors.dart';

class PersonalSettingsPage extends StatefulWidget {
  const PersonalSettingsPage({Key? key}) : super(key: key);

  @override
  State<PersonalSettingsPage> createState() => _PersonalSettingsPageState();
}
final _formKey = GlobalKey<FormState>();
String? first_name, last_name, biography,education;
List<String>? interests = [];
List<String> genderChoices = ['Male','Female','Non-binary','Prefer not to say', 'Other'];
List<String> educationChoices = ['Doctorate Degree', 'Master\'s Degree', 'Bachelor\'s Degree' , 'Certificate or Diploma' , 'High School'];
String? firstNameError, lastNameError, ageError;

bool _isUpdating = false;

class _PersonalSettingsPageState extends State<PersonalSettingsPage> {
  Rx<LocalStorage> localStorage =
      LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
  String? title;
  bool isSaved = false;
  bool isValueSet = false;
  AuthController authController = Get.put(AuthController());

  ProfileController profileController = Get.put(ProfileController());

  late int age;
  late String gender;

  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    profileController.getAuthenticatedUser();
    first_name = profileController.authenticatedUser.value.firstName??" ";
    last_name = profileController.authenticatedUser.value.lastName??" ";
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    setState(() {
      _isLoading = true;
    });
    ProfileController profileController = Get.put(ProfileController());

    try {
      UserProfile userProfile = await _apiService.fetchUserProfile(userName:profileController.authenticatedUser.value.username!);

      setState(() {
        age = userProfile.age!;
        gender = userProfile.gender == ""?genderChoices[3]:userProfile.gender!;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Handle any errors that occurred during the API request
      print('Error fetching user profile: $e');
    }
  }
  Future<String> updateUserProfile(firstName,lastName) async {
    setState(() {
      _isUpdating = true;
    });
    try {
      UserProfile updatedProfile = UserProfile(
        // Set the updated values for the profile properties
        firstName: firstName,
        lastName: lastName,
        age: age,
        gender: gender,
      );
      String updatedValues = await _apiService.updateUserProfile(
        updatedProfile: updatedProfile,
      );
      setState(() {
        _isUpdating = false;
      });
      localStorage.value.updateUserInfo(firstName: firstName,lastName: lastName);
      return updatedValues;
    } catch (e) {
      setState(() {
        _isUpdating = false;
      });
      print('Error updating user profile: $e');
      return '';
    }
  }


  void _saveSelectedChoice(String choice) {
    setState(() {
      education = choice;
    });
  }
  void _saveSelectedChoiceGender(String choice) {
    setState(() {
      gender = choice;
    });
  }


  @override
  Widget build(BuildContext context) {
    final firstName = profileController.authenticatedUser.value.firstName ?? " ";
    final lastName = profileController.authenticatedUser.value.lastName??" ";
    if(_isLoading){
      return Scaffold(backgroundColor: mainBackgroundColor,body: Center(child: CircularProgressIndicator()),);
    }
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
                Text('Personal Settings', textAlign: TextAlign.end, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white)),
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
                  _container(context, false, null, firstName, TextInputType.name,BoxIcons.bx_user, 20, firstName, "fName", (() {})),
                  firstNameError != null && isSaved ? errorMessage(firstNameError.toString()) : Container(),
                  _container(context, false, null, lastName, TextInputType.name, BoxIcons.bx_user, 20, lastName, "lName", (() {})),
                  lastNameError != null && isSaved ? errorMessage(lastNameError.toString()) : Container(),
                  _container(context, false, null, "", TextInputType.name, BoxIcons.bx_user, 0, "", "bio", (() {}),maxLines: 8),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Education",
                            style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.w800,
                                fontSize: 20
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity, // Cover the whole width
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15), // Apply border radius
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),// Set the background color to white
                        child: Align(
                          alignment: Alignment.center, // Align the dropdown to the center
                          child: Container(
                            width: double.infinity, // Set the width of the dropdown
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15), // Apply border radius
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: DropdownButton<String>(
                              value: education, // Set the initial value to the first choice (placeholder)
                              items: educationChoices.map((String choice) {
                                return DropdownMenuItem<String>(
                                  value: choice,
                                  child:  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(choice,style: TextStyle(fontSize: 16),),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                _saveSelectedChoice(newValue!);
                              },
                              style: TextStyle(color: Colors.black), // Customize the text color
                              dropdownColor: Colors.white, // Customize the dropdown menu's background color
                              icon: Icon(Icons.arrow_drop_down), // Custom dropdown arrow icon
                              iconSize: 24, // Set the icon size as needed
                              isExpanded: true, // Expand the dropdown to cover the width
                              underline: SizedBox(), // Remove the default underline
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Gender",
                            style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.w800,
                                fontSize: 20
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity, // Cover the whole width
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15), // Apply border radius
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),// Set the background color to white
                        child: Align(
                          alignment: Alignment.center, // Align the dropdown to the center
                          child: Container(
                            width: double.infinity, // Set the width of the dropdown
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15), // Apply border radius
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: DropdownButton<String>(
                              value: gender, // Set the initial value to the first choice (placeholder)
                              items: genderChoices.map((String choice) {
                                return DropdownMenuItem<String>(
                                  value: choice,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(choice,style: TextStyle(fontSize: 16),),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                _saveSelectedChoiceGender(newValue!);
                              },
                              style: TextStyle(color: Colors.black), // Customize the text color
                              dropdownColor: Colors.white, // Customize the dropdown menu's background color
                              icon: Icon(Icons.arrow_drop_down), // Custom dropdown arrow icon
                              iconSize: 24, // Set the icon size as needed
                              isExpanded: true, // Expand the dropdown to cover the width
                              underline: SizedBox(), // Remove the default underline
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  _container(
                    context,
                    false,
                    null,
                    age==0?"":age.toString(),
                    TextInputType.number,
                    BoxIcons.bx_briefcase,
                    21,
                    age.toString(),
                    "age",
                    (() {}),
                  ),
                  ageError != null && isSaved ? errorMessage(ageError.toString()) : Container(),
                ])),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
              child: buildButton("Save", (() async {
                isSaved = false;
                final isValidForm = _formKey.currentState!.validate();
                setState(() {
                  isSaved = true;
                });
                if (isValidForm) {
                  print("first name " + first_name!);
                  updateUserProfile(first_name,last_name).then((String updatedValues) {
                    print('Updated values: $updatedValues');
                    var snackBar = SnackBar(
                      content: Text(
                        'personal settings successfully set',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height - 100,
                        left: 10,
                        right: 10,
                      ),
                      action: SnackBarAction(
                        label: 'ok',
                        textColor: Colors.white,
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }).catchError((error) {
                    print('Error updating user profile: $error');
                  });

                }
              }), const Color(0xFFF400D7), const Color(0xFFFF00D7)),
            ),
          ),

        ]),
      ),
    );
  }
  String? hintText(String? inputType) {
    if (inputType == "fName") {
      return "First Name";
    } else if (inputType == "lName") {
      return "Last Name";
    }
    else if (inputType == "bio") {
      return "Biography";
    }else if (inputType == "age") {
      return "Age";
    }
    return null;
  }

  Widget _container(BuildContext context, bool readOnly,TextEditingController? controller, String? initialValue, TextInputType? inputType,
      IconData icon, double iconSize, String? value, String? type, VoidCallback onTap,
      {maxLines = 1}) {
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
                    maxLines: maxLines,
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
                      if (type == "fName") {
                        first_name = value;
                      } else if (type == "lName") {
                        last_name = value;
                      } else if (type == "age") {
                        age = int.parse(value);
                      }
                      else if(type == "bio"){
                        biography = value;
                      }
                    },
                    validator: ((value) {
                      if (type == "fName") {
                        if (value != null && value.length < 1) {
                          firstNameError = "Please enter your First name";
                          return firstNameError;
                        } else {
                          firstNameError = null;
                          return null;
                        }
                      }

                      else if (type == "lName") {
                        if (value != null && value.length < 1) {
                          lastNameError = "Please enter your Last name";
                          return lastNameError;
                        } else {
                          lastNameError = null;
                          return null;
                        }
                      }
                      // else if (type == "uEmail") {
                      //   final emailRegex = RegExp(
                      //       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                      //   if (value!.isEmpty) {
                      //     userEmailError = "Please enter a valid email address (ex. abc@gmail.com)";
                      //     return userEmailError;
                      //   } else if (emailRegex.hasMatch(value) == false) {
                      //     userEmailError = "Please enter a valid email address (ex. abc@gmail.com)";
                      //     return userEmailError;
                      //   }
                      //   userEmailError = null;
                      //   return null;
                      // }
                      else if (type == "age") {
                        if (value != null && value.length < 1) {
                          ageError = "Please enter your age";
                          return ageError;
                        }
                        else if (!isNumeric(value!)) {
                          ageError = 'Please enter a valid age';
                          return ageError;
                        }else {
                          ageError = null;
                          return null;
                        }
                      }
                      return null;
                    })))),
      ],
    );
  }
}
bool isNumeric(String value) {
  return double.tryParse(value) != null;
}
Widget buildButton(String label, VoidCallback onTap, Color color1, Color color2) {
  return SizedBox(
    key: UniqueKey(),
    width: 150,
    height: 50,
    child: GestureDetector(
      onTap: _isUpdating?null:onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: _isUpdating?LinearGradient(
            colors: [Colors.white, Colors.white, Colors.white, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ):LinearGradient(
            colors: [color1, color1, color1, color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: !_isUpdating?Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ):Text(
              "saving...",
              style: const TextStyle(color: Colors.purpleAccent, fontSize: 20),
            )
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