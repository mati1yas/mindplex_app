import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mindplex_app/utils/colors.dart';

import '../routes/app_routes.dart';

class PreferencePage extends StatefulWidget {
  const PreferencePage({Key? key}) : super(key: key);

  @override
  State<PreferencePage> createState() => _PreferencePageState();
}

enum PrivacyPreference { public ,friends , private }

class _PreferencePageState extends State<PreferencePage> {

  PrivacyPreference? _character = PrivacyPreference.private;
  bool _label1 = false,_label2 = false,_label3 = false,_label4 = false,_label5 = false;
  @override
  Widget build(BuildContext context) {
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
          Text('Preferences', textAlign: TextAlign.end, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white)),
          const SizedBox(width: 35)
        ],
      ),
    ),

        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Privacy preference",
                  style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.w800,
                      fontSize: 25
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left:25.0,top: 8.0),
              child: Container(alignment:Alignment.centerLeft,
        child: Text("who should see your age",textAlign: TextAlign.left,style: TextStyle(fontSize: 20,color: Colors.white),)),
            ),
            Padding(
              padding: const EdgeInsets.only(left:64.0,top: 10.0),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('public',style: TextStyle(color: Colors.white),),
                    leading: Radio<PrivacyPreference>(
                      value: PrivacyPreference.public,
                      groupValue: _character,
                      onChanged: (PrivacyPreference? value) {
                        setState(() {
                          _character = value;
                        });
                      },
                      fillColor: MaterialStateColor.resolveWith((states) => Colors.purpleAccent),
                    ),
                  ),
                  ListTile(
                    title: const Text('friends',style: TextStyle(color: Colors.white),),
                    leading: Radio<PrivacyPreference>(
                      value: PrivacyPreference.friends,
                      groupValue: _character,
                      onChanged: (PrivacyPreference? value) {
                        setState(() {
                          _character = value;
                        });
                      },
                      fillColor: MaterialStateColor.resolveWith((states) => Colors.purpleAccent),
                    ),
                  ),
                  ListTile(
                    title: const Text('private',style: TextStyle(color: Colors.white),),
                    leading: Radio<PrivacyPreference>(
                      value: PrivacyPreference.private,
                      groupValue: _character,
                      onChanged: (PrivacyPreference? value) {
                        setState(() {
                          _character = value;
                        });
                      },
                      fillColor: MaterialStateColor.resolveWith((states) => Colors.purpleAccent),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:25.0,top: 8.0),
              child: Container(alignment:Alignment.centerLeft,
                  child: Text("who should see your gender",textAlign: TextAlign.left,style: TextStyle(fontSize: 20,color: Colors.white),)),
            ),
            Padding(
              padding: const EdgeInsets.only(left:64.0,top: 10.0),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('public',style: TextStyle(color: Colors.white),),
                    leading: Radio<PrivacyPreference>(
                      value: PrivacyPreference.public,
                      groupValue: _character,
                      onChanged: (PrivacyPreference? value) {
                        setState(() {
                          _character = value;
                        });
                      },
                      fillColor: MaterialStateColor.resolveWith((states) => Colors.purpleAccent),
                    ),
                  ),
                  ListTile(
                    title: const Text('friends',style: TextStyle(color: Colors.white),),
                    leading: Radio<PrivacyPreference>(
                      value: PrivacyPreference.friends,
                      groupValue: _character,
                      onChanged: (PrivacyPreference? value) {
                        setState(() {
                          _character = value;
                        });
                      },
                      fillColor: MaterialStateColor.resolveWith((states) => Colors.purpleAccent),
                    ),
                  ),
                  ListTile(
                    title: const Text('private',style: TextStyle(color: Colors.white),),
                    leading: Radio<PrivacyPreference>(
                      value: PrivacyPreference.private,
                      groupValue: _character,
                      onChanged: (PrivacyPreference? value) {
                        setState(() {
                          _character = value;
                        });
                      },
                      fillColor: MaterialStateColor.resolveWith((states) => Colors.purpleAccent),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:25.0,top: 8.0),
              child: Container(alignment:Alignment.centerLeft,
                  child: Text("who should see your education",textAlign: TextAlign.left,style: TextStyle(fontSize: 20,color: Colors.white),)),
            ),
            Padding(
              padding: const EdgeInsets.only(left:64.0,top: 10.0),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('public',style: TextStyle(color: Colors.white),),
                    leading: Radio<PrivacyPreference>(
                      value: PrivacyPreference.public,
                      groupValue: _character,
                      onChanged: (PrivacyPreference? value) {
                        setState(() {
                          _character = value;
                        });
                      },
                      fillColor: MaterialStateColor.resolveWith((states) => Colors.purpleAccent),
                    ),
                  ),
                  ListTile(
                    title: const Text('friends',style: TextStyle(color: Colors.white),),
                    leading: Radio<PrivacyPreference>(
                      value: PrivacyPreference.friends,
                      groupValue: _character,
                      onChanged: (PrivacyPreference? value) {
                        setState(() {
                          _character = value;
                        });
                      },
                      fillColor: MaterialStateColor.resolveWith((states) => Colors.purpleAccent),
                    ),
                  ),
                  ListTile(
                    title: const Text('private',style: TextStyle(color: Colors.white),),
                    leading: Radio<PrivacyPreference>(
                      value: PrivacyPreference.private,
                      groupValue: _character,
                      onChanged: (PrivacyPreference? value) {
                        setState(() {
                          _character = value;
                        });
                      },
                      fillColor: MaterialStateColor.resolveWith((states) => Colors.purpleAccent),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email preference",
                  style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.w800,
                      fontSize: 25
                  ),
                ),
              ),
            ),
            Center(
              child: LabeledCheckbox(
                label: ' Emails from Mindplex notifying you of new articles, news, or media.',
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                value: _label1,
                onChanged: (bool newValue) {
                  setState(() {
                    _label1 = newValue;
                  });
                },
              ),
            ),
            SizedBox(height: 15,),
            Center(
              child: LabeledCheckbox(
                label: ' Notification emails, receive emails when someone you follow publishes content.',
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                value: _label2,
                onChanged: (bool newValue) {
                  setState(() {
                    _label2 = newValue;
                  });
                },
              ),
            ),
            SizedBox(height: 15,),
            Center(
              child: LabeledCheckbox(
                label: ' Interaction emails: receive emails when someone comments on your content.',
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                value: _label3,
                onChanged: (bool newValue) {
                  setState(() {
                    _label3 = newValue;
                  });
                },
              ),
            ),
            SizedBox(height: 15,),
            Center(
              child: LabeledCheckbox(
                label: ' Weekly digest emails, receive emails about the week’s popular, recommended, editor’s picks, most reputable, and people’s choice articles.',
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                value: _label4,
                onChanged: (bool newValue) {
                  setState(() {
                    _label4 = newValue;
                  });
                },
              ),
            ),
            SizedBox(height: 15,),
            Center(
              child: LabeledCheckbox(
                label: 'Mindplex updates, receive timely company announcments and community updates.',
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                value: _label5,
                onChanged: (bool newValue) {
                  setState(() {
                    _label5 = newValue;
                  });
                },
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: buildButton("Save", (() async {
                print(_label1);
              }), const Color(0xFFF400D7), const Color(0xFFFF00D7)),
            ),
          ],
        )],),),);
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
        padding: padding,
        child: Row(
          children: <Widget>[
            Checkbox(
              value: value,
              onChanged: (bool? newValue) {
                onChanged(newValue!);
              },
              fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
              checkColor: MaterialStateColor.resolveWith((states) => Colors.purpleAccent),
            ),
            Expanded(child: Text(label , style: TextStyle(color: Colors.white , fontSize: 16),)),
          ],
        ),
      ),
    );
  }
}
