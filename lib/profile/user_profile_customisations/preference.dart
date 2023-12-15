import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mindplex/profile/user_profile_controller.dart';
import 'package:mindplex/utils/colors.dart';

import '../../models/user_profile.dart';
import '../../routes/app_routes.dart';
import '../../services/api_services.dart';

class PreferencePage extends StatefulWidget {
  const PreferencePage({Key? key}) : super(key: key);

  @override
  State<PreferencePage> createState() => _PreferencePageState();
}

enum PrivacyPreference { public, friends, private }

PrivacyPreference maptoPrivacyPreference(String pref) {
  if (pref == "Private") {
    return PrivacyPreference.private;
  } else if (pref == "Public") {
    return PrivacyPreference.public;
  } else if (pref == "Friends") {
    return PrivacyPreference.friends;
  } else {
    return PrivacyPreference.private;
  }
}

String? mapPrivacyPreferenceToString(PrivacyPreference p) {
  if (p == PrivacyPreference.public) {
    return "Public";
  } else if (p == PrivacyPreference.private) {
    return "Private";
  } else if (p == PrivacyPreference.friends) {
    return "Friends";
  }
  return null;
}

bool _isUpdating = false;

class _PreferencePageState extends State<PreferencePage> {
  PrivacyPreference? _agePreference, _genderPreference, _educationPreference;
  bool lightMode = true, darkMode = false, system = false;
  bool? _notifyPublications,
      _notifyEmail,
      _notifyInteraction,
      _notifyWeekly,
      _notifyUpdates;

  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    setState(() {
      _isLoading = true;
    });
    ProfileController profileController = Get.put(ProfileController());

    try {
      UserProfile userProfile = await _apiService.fetchUserProfile(
          userName: profileController.authenticatedUser.value.username!);

      setState(() {
        _agePreference = maptoPrivacyPreference(userProfile.agePreference!);
        _genderPreference =
            maptoPrivacyPreference(userProfile.genderPreference!);
        _educationPreference =
            maptoPrivacyPreference(userProfile.educationPreference!);
        _notifyPublications = userProfile.notifyPublications!;
        _notifyEmail = userProfile.notifyFollower!;
        _notifyInteraction = userProfile.notifyInteraction!;
        _notifyWeekly = userProfile.notifyWeekly!;
        _notifyUpdates = userProfile.notifyUpdates!;
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

  Future<String> updateUserProfile() async {
    setState(() {
      _isUpdating = true;
    });
    try {
      print(_agePreference);
      UserProfile updatedProfile = UserProfile(
        // Set the updated values for the profile properties
        agePreference: mapPrivacyPreferenceToString(_agePreference!),
        genderPreference: mapPrivacyPreferenceToString(_genderPreference!),
        educationPreference:
            mapPrivacyPreferenceToString(_educationPreference!),
        notifyPublications: _notifyPublications,
        notifyFollower: _notifyEmail,
        notifyInteraction: _notifyInteraction,
        notifyWeekly: _notifyWeekly,
        notifyUpdates: _notifyUpdates,
      );
      String updatedValues = await _apiService.updateUserProfile(
        updatedProfile: updatedProfile,
      );
      setState(() {
        _isUpdating = false;
      });
      return updatedValues;
    } catch (e) {
      setState(() {
        _isUpdating = false;
      });
      print('Error updating user profile: $e');
      return '';
    }
  }

  void toogleColorTheme(String mode, bool newValue) {
    if (mode == "light") {
      if (newValue == false) {
        setState(() {
          darkMode = true;
          lightMode = false;
        });
      } else {
        setState(() {
          lightMode = true;
          darkMode = false;
          system = false;
        });
      }
    } else if (mode == "dark") {
      if (newValue == false) {
        setState(() {
          lightMode = true;
          darkMode = false;
        });
      } else {
        setState(() {
          lightMode = false;
          darkMode = true;
          system = false;
        });
      }
    } else if (mode == "system") {
      if (newValue == false) {
        setState(() {
          system = false;
          lightMode = true;
        });
      } else {
        setState(() {
          lightMode = false;
          darkMode = false;
          system = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: mainBackgroundColor,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Color theme",
                      style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Theme(
                              data: ThemeData(
                                checkboxTheme: CheckboxThemeData(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  side: BorderSide(
                                      color: Colors.white, width: 1.5),
                                  fillColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.white),
                                  checkColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.transparent),
                                ),
                              ),
                              child: Checkbox(
                                  activeColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.pinkAccent),
                                  value: darkMode,
                                  onChanged: (bool? newValue) {
                                    toogleColorTheme("dark", newValue!);
                                  }),
                            ),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.dark_mode_outlined,
                              size: 30,
                              color: Colors.white,
                            ),
                            Text(
                              "Dark",
                              style:
                                  TextStyle(color: Colors.amber, fontSize: 16),
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Theme(
                              data: ThemeData(
                                checkboxTheme: CheckboxThemeData(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  side: BorderSide(
                                      color: Colors.white, width: 1.5),
                                  fillColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.white),
                                  checkColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.transparent),
                                ),
                              ),
                              child: Checkbox(
                                  activeColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.pinkAccent),
                                  value: lightMode,
                                  onChanged: (bool? newValue) {
                                    toogleColorTheme("light", newValue!);
                                  }),
                            ),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.light_mode_outlined,
                              size: 30,
                              color: Colors.white,
                            ),
                            Text(
                              "Light",
                              style:
                                  TextStyle(color: Colors.amber, fontSize: 16),
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Theme(
                          data: ThemeData(
                            checkboxTheme: CheckboxThemeData(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              side: BorderSide(color: Colors.white, width: 1.5),
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              checkColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.transparent),
                            ),
                          ),
                          child: Checkbox(
                              activeColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.pinkAccent),
                              value: system,
                              onChanged: (bool? newValue) {
                                toogleColorTheme("system", newValue!);
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Text(
                            "Use System Preferences",
                            style: TextStyle(color: Colors.amber, fontSize: 16),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Privacy preference",
                      style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 8.0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "who should see your age",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 0.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text(
                          'public',
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Radio<PrivacyPreference>(
                          value: PrivacyPreference.public,
                          groupValue: _agePreference,
                          onChanged: (PrivacyPreference? value) {
                            setState(() {
                              _agePreference = value;
                            });
                          },
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Colors.pinkAccent),
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          'friends',
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Radio<PrivacyPreference>(
                          value: PrivacyPreference.friends,
                          groupValue: _agePreference,
                          onChanged: (PrivacyPreference? value) {
                            setState(() {
                              _agePreference = value;
                            });
                          },
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Colors.pinkAccent),
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          'private',
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Radio<PrivacyPreference>(
                          value: PrivacyPreference.private,
                          groupValue: _agePreference,
                          onChanged: (PrivacyPreference? value) {
                            setState(() {
                              _agePreference = value;
                            });
                          },
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Colors.pinkAccent),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 8.0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "who should see your gender",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 0.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text(
                          'public',
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Radio<PrivacyPreference>(
                          value: PrivacyPreference.public,
                          groupValue: _genderPreference,
                          onChanged: (PrivacyPreference? value) {
                            setState(() {
                              _genderPreference = value;
                            });
                          },
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Colors.pinkAccent),
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          'friends',
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Radio<PrivacyPreference>(
                          value: PrivacyPreference.friends,
                          groupValue: _genderPreference,
                          onChanged: (PrivacyPreference? value) {
                            setState(() {
                              _genderPreference = value;
                            });
                          },
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Colors.pinkAccent),
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          'private',
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Radio<PrivacyPreference>(
                          value: PrivacyPreference.private,
                          groupValue: _genderPreference,
                          onChanged: (PrivacyPreference? value) {
                            setState(() {
                              _genderPreference = value;
                            });
                          },
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Colors.pinkAccent),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 8.0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "who should see your education",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 0.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text(
                          'public',
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Radio<PrivacyPreference>(
                          value: PrivacyPreference.public,
                          groupValue: _educationPreference,
                          onChanged: (PrivacyPreference? value) {
                            setState(() {
                              _educationPreference = value;
                            });
                          },
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Colors.pinkAccent),
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          'friends',
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Radio<PrivacyPreference>(
                          value: PrivacyPreference.friends,
                          groupValue: _educationPreference,
                          onChanged: (PrivacyPreference? value) {
                            setState(() {
                              _educationPreference = value;
                            });
                          },
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Colors.pinkAccent),
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          'private',
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Radio<PrivacyPreference>(
                          value: PrivacyPreference.private,
                          groupValue: _educationPreference,
                          onChanged: (PrivacyPreference? value) {
                            setState(() {
                              _educationPreference = value;
                            });
                          },
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Colors.pinkAccent),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Email preference",
                      style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                  ),
                ),
                Center(
                  child: LabeledCheckbox(
                    label:
                        ' Emails from Mindplex notifying you of new articles, news, or media.',
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    value: _notifyPublications!,
                    onChanged: (bool newValue) {
                      setState(() {
                        _notifyPublications = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: LabeledCheckbox(
                    label:
                        ' Notification emails, receive emails when someone you follow publishes content.',
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    value: _notifyEmail!,
                    onChanged: (bool newValue) {
                      setState(() {
                        _notifyEmail = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: LabeledCheckbox(
                    label:
                        ' Interaction emails: receive emails when someone comments on your content.',
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    value: _notifyInteraction!,
                    onChanged: (bool newValue) {
                      setState(() {
                        _notifyInteraction = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: LabeledCheckbox(
                    label:
                        ' Weekly digest emails, receive emails about the week’s popular, recommended, editor’s picks, most reputable, and people’s choice articles.',
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    value: _notifyWeekly!,
                    onChanged: (bool newValue) {
                      setState(() {
                        _notifyWeekly = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: LabeledCheckbox(
                    label:
                        'Mindplex updates, receive timely company announcments and community updates.',
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    value: _notifyUpdates!,
                    onChanged: (bool newValue) {
                      setState(() {
                        _notifyUpdates = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Deactivate Account",
                      style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left:
                          10.0), // Adjust the margin value as per your preference
                  child: Text(
                    'Deactivating your account will remove it from mindplex megazine. Deactivation will also immediately cancel any subscription for mindplex megazine Membership, and no money will be reimbursed. You can sign back in anytime to reactivate your account and restore its content.',
                    style: TextStyle(
                        fontSize: 16.0, color: Colors.white, height: 1.3),
                  ),
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildButton("Deactivate", () {
                        print("Account Deactivated");
                      }, Color.fromARGB(255, 58, 58, 58), true),
                    )),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Delete Account",
                      style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left:
                          10.0), // Adjust the margin value as per your preference
                  child: Text(
                    'Permanently delete your account from mindplex '
                    'and your reputation token(MPXR) from the mindplex ecosystem.',
                    style: TextStyle(
                        fontSize: 16.0, color: Colors.white, height: 1.3),
                  ),
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildButton("Delete", () {
                        print("Account Deleted");
                      }, Color.fromARGB(255, 211, 58, 58), true),
                    )),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildButton("Cancel", () async {
                        print("canceled");
                      }, Colors.blueAccent, false),
                      buildButton("Save", (() async {
                        updateUserProfile().then((String updatedValues) {
                          print('Updated values: $updatedValues');
                          var snackBar = SnackBar(
                            content: Text(
                              'preferences successfully set',
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
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                              },
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }).catchError((error) {
                          print('Error updating user profile: $error');
                        });
                      }), Colors.blueAccent.shade200, true)
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget buildButton(String label, VoidCallback onTap, Color color1, bool fill) {
  return SizedBox(
    key: UniqueKey(),
    width: 150,
    height: label == "Add link" ? 35 : 50,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: fill
            ? BoxDecoration(
                color: color1,
                borderRadius: BorderRadius.circular(10),
              )
            : BoxDecoration(
                border: Border.all(color: color1),
                borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            label,
            style: fill
                ? TextStyle(color: Colors.white, fontSize: 20)
                : TextStyle(color: color1, fontSize: 20),
          ),
        ),
      ),
    ),
  );
}

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    super.key,
    required this.label,
    required this.padding,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: EdgeInsets.only(left: 8.0, right: 8.0),
        child: Row(
          children: <Widget>[
            Theme(
              data: ThemeData(
                checkboxTheme: CheckboxThemeData(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  side: BorderSide(color: Colors.transparent),
                  fillColor:
                      MaterialStateColor.resolveWith((states) => Colors.white),
                  checkColor: MaterialStateColor.resolveWith(
                      (states) => Colors.transparent),
                ),
              ),
              child: Checkbox(
                activeColor: MaterialStateColor.resolveWith(
                    (states) => Color.fromARGB(255, 255, 73, 139)),
                value: value,
                onChanged: (bool? newValue) {
                  onChanged(newValue!);
                },
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                label,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
