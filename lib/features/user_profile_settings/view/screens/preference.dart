import 'dart:ffi';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';
import 'package:mindplex/features/user_profile_settings/controllers/preference_controller.dart';
import 'package:mindplex/features/user_profile_settings/models/privacy_preference.dart';
import 'package:mindplex/features/user_profile_settings/view/widgets/labeled_radio_button_widget.dart';
import 'package:mindplex/utils/colors.dart';

import '../../../../services/api_services.dart';
import '../../models/user_profile.dart';
import '../widgets/button_widget.dart';
import '../widgets/labeled_checkbox_widget.dart';

class PreferencePage extends StatefulWidget {
  const PreferencePage({Key? key}) : super(key: key);

  @override
  State<PreferencePage> createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
  PreferenceController preferenceController = Get.put(PreferenceController());
  @override
  void initState() {
    super.initState();
    preferenceController.fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => preferenceController.isLoading.value
        ? Scaffold(
            backgroundColor: mainBackgroundColor,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: mainBackgroundColor,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Column(
                      children: <Widget>[
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Container(
                        //     alignment: Alignment.centerLeft,
                        //     child: Text(
                        //       "Color theme",
                        //       style: TextStyle(
                        //           color: Colors.amber,
                        //           fontWeight: FontWeight.w500,
                        //           fontSize: 20),
                        //     ),
                        //   ),
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Row(
                        //       children: [
                        //         Column(
                        //           children: [
                        //             Theme(
                        //               data: ThemeData(
                        //                 checkboxTheme: CheckboxThemeData(
                        //                   shape: RoundedRectangleBorder(
                        //                     borderRadius:
                        //                         BorderRadius.circular(16.0),
                        //                   ),
                        //                   side: BorderSide(
                        //                       color: Colors.white, width: 1.5),
                        //                   fillColor:
                        //                       MaterialStateColor.resolveWith(
                        //                           (states) => Colors.white),
                        //                   checkColor:
                        //                       MaterialStateColor.resolveWith(
                        //                           (states) => Colors.transparent),
                        //                 ),
                        //               ),
                        //               child: Checkbox(
                        //                   activeColor:
                        //                       MaterialStateColor.resolveWith(
                        //                           (states) => Colors.pinkAccent),
                        //                   value:
                        //                       preferenceController.darkMode.value,
                        //                   onChanged: (bool? newValue) {
                        //                     preferenceController.toogleColorTheme(
                        //                         "dark", newValue!);
                        //                   }),
                        //             ),
                        //             SizedBox(
                        //               height: 5,
                        //             )
                        //           ],
                        //         ),
                        //         Column(
                        //           children: [
                        //             Icon(
                        //               Icons.dark_mode_outlined,
                        //               size: 30,
                        //               color: Colors.white,
                        //             ),
                        //             Text(
                        //               "Dark",
                        //               style: TextStyle(
                        //                   color: Colors.amber, fontSize: 16),
                        //             )
                        //           ],
                        //         ),
                        //       ],
                        //     ),
                        //     Row(
                        //       children: [
                        //         Column(
                        //           children: [
                        //             Theme(
                        //               data: ThemeData(
                        //                 checkboxTheme: CheckboxThemeData(
                        //                   shape: RoundedRectangleBorder(
                        //                     borderRadius:
                        //                         BorderRadius.circular(16.0),
                        //                   ),
                        //                   side: BorderSide(
                        //                       color: Colors.white, width: 1.5),
                        //                   fillColor:
                        //                       MaterialStateColor.resolveWith(
                        //                           (states) => Colors.white),
                        //                   checkColor:
                        //                       MaterialStateColor.resolveWith(
                        //                           (states) => Colors.transparent),
                        //                 ),
                        //               ),
                        //               child: Checkbox(
                        //                   activeColor:
                        //                       MaterialStateColor.resolveWith(
                        //                           (states) => Colors.pinkAccent),
                        //                   value: preferenceController
                        //                       .lightMode.value,
                        //                   onChanged: (bool? newValue) {
                        //                     preferenceController.toogleColorTheme(
                        //                         "light", newValue!);
                        //                   }),
                        //             ),
                        //             SizedBox(
                        //               height: 5,
                        //             )
                        //           ],
                        //         ),
                        //         Column(
                        //           children: [
                        //             Icon(
                        //               Icons.light_mode_outlined,
                        //               size: 30,
                        //               color: Colors.white,
                        //             ),
                        //             Text(
                        //               "Light",
                        //               style: TextStyle(
                        //                   color: Colors.amber, fontSize: 16),
                        //             )
                        //           ],
                        //         ),
                        //       ],
                        //     ),
                        //     Row(
                        //       children: [
                        //         Theme(
                        //           data: ThemeData(
                        //             checkboxTheme: CheckboxThemeData(
                        //               shape: RoundedRectangleBorder(
                        //                 borderRadius: BorderRadius.circular(16.0),
                        //               ),
                        //               side: BorderSide(
                        //                   color: Colors.white, width: 1.5),
                        //               fillColor: MaterialStateColor.resolveWith(
                        //                   (states) => Colors.white),
                        //               checkColor: MaterialStateColor.resolveWith(
                        //                   (states) => Colors.transparent),
                        //             ),
                        //           ),
                        //           child: Checkbox(
                        //               activeColor: MaterialStateColor.resolveWith(
                        //                   (states) => Colors.pinkAccent),
                        //               value: preferenceController.system.value,
                        //               onChanged: (bool? newValue) {
                        //                 preferenceController.toogleColorTheme(
                        //                     "system", newValue!);
                        //               }),
                        //         ),
                        //         Padding(
                        //           padding: const EdgeInsets.only(right: 10.0),
                        //           child: Text(
                        //             "Use System Preferences",
                        //             style: TextStyle(
                        //                 color: Colors.amber, fontSize: 16),
                        //           ),
                        //         )
                        //       ],
                        //     )
                        //   ],
                        // ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, top: 8.0, right: 8),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Privacy preference",
                              style: TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 22),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                          ),
                          child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "who should see your age",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 0.0),
                          child: Column(
                            children: [
                              labeledRadioButton(
                                  "public", PrivacyPreference.public, 1),
                              labeledRadioButton(
                                  "friends", PrivacyPreference.friends, 1),
                              labeledRadioButton(
                                  "private", PrivacyPreference.private, 1)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                          child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "who should see your gender",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 0.0),
                          child: Column(
                            children: [
                              labeledRadioButton(
                                  "public", PrivacyPreference.public, 2),
                              labeledRadioButton(
                                  "friends", PrivacyPreference.friends, 2),
                              labeledRadioButton(
                                  "private", PrivacyPreference.private, 2)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                          child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "who should see your education",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 0.0),
                          child: Column(
                            children: [
                              labeledRadioButton(
                                  "public", PrivacyPreference.public, 3),
                              labeledRadioButton(
                                  "friends", PrivacyPreference.friends, 3),
                              labeledRadioButton(
                                  "private", PrivacyPreference.private, 3)
                            ],
                          ),
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
                                  fontSize: 22),
                            ),
                          ),
                        ),
                        Center(
                          child: LabeledCheckbox(
                            label:
                                ' Emails from Mindplex notifying you of new articles, news, or media.',
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            value:
                                preferenceController.notifyPublications!.value,
                            onChanged: (bool newValue) {
                              preferenceController.notifyPublications!.value =
                                  newValue;
                            },
                          ),
                        ),

                        Center(
                          child: LabeledCheckbox(
                            label:
                                ' Notification emails, receive emails when someone you follow publishes content.',
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            value: preferenceController.notifyEmail!.value!,
                            onChanged: (bool newValue) {
                              preferenceController.notifyEmail!.value =
                                  newValue;
                            },
                          ),
                        ),

                        Center(
                          child: LabeledCheckbox(
                            label:
                                ' Interaction emails: receive emails when someone comments on your content.',
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            value:
                                preferenceController.notifyInteraction!.value,
                            onChanged: (bool newValue) {
                              preferenceController.notifyInteraction!.value =
                                  newValue;
                            },
                          ),
                        ),

                        Center(
                          child: LabeledCheckbox(
                            label:
                                ' Weekly digest emails, receive emails about the week’s popular, recommended, editor’s picks, most reputable, and people’s choice articles.',
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            value: preferenceController.notifyWeekly!.value,
                            onChanged: (bool newValue) {
                              setState(() {
                                preferenceController.notifyWeekly!.value =
                                    newValue;
                              });
                            },
                          ),
                        ),

                        Center(
                          child: LabeledCheckbox(
                            label:
                                'Mindplex updates, receive timely company announcments and community updates.',
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            value: preferenceController.notifyUpdates!.value,
                            onChanged: (bool newValue) {
                              setState(() {
                                preferenceController.notifyUpdates!.value =
                                    newValue;
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
                                fontSize: 15.0,
                                color: Colors.white,
                                height: 1.3),
                          ),
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: buildButton("Deactivate", () {
                                print("Account Deactivated");
                              }, Color.fromARGB(255, 58, 58, 58), true,
                                  context),
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
                                fontSize: 15.0,
                                color: Colors.white,
                                height: 1.3),
                          ),
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: buildButton("Delete", () {
                                print("Account Deleted");
                              }, Color.fromARGB(255, 211, 58, 58), true,
                                  context),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            buildButton("Cancel", () async {
                              print("canceled");
                            }, Colors.blueAccent, false, context),
                            buildButton("Save", (() async {
                              preferenceController.updateUserProfile();
                            }), Colors.blueAccent.shade200, true, context)
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ));
  }
}
