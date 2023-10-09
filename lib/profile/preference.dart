import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mindplex_app/profile/user_profile_controller.dart';
import 'package:mindplex_app/utils/colors.dart';

import '../models/user_profile.dart';
import '../routes/app_routes.dart';
import '../services/api_services.dart';

class PreferencePage extends StatefulWidget {
  const PreferencePage({Key? key}) : super(key: key);

  @override
  State<PreferencePage> createState() => _PreferencePageState();
}

enum PrivacyPreference { public ,friends , private }

PrivacyPreference maptoPrivacyPreference(String pref){
  if(pref == "Private"){
    return PrivacyPreference.private;
  }
  else if(pref == "Public"){
    return PrivacyPreference.public;
  }
  else if(pref == "Friends"){
    return PrivacyPreference.friends;
  }
  else{
    return PrivacyPreference.private;
  }
}
String? mapPrivacyPreferenceToString(PrivacyPreference p){
  if(p == PrivacyPreference.public){
    return "Public";
  }
  else if(p == PrivacyPreference.private){
    return "Private";
  }
  else if(p == PrivacyPreference.friends){
    return "Friends";
  }
  return null;
}
bool _isUpdating = false;

class _PreferencePageState extends State<PreferencePage> {

  PrivacyPreference? _agePreference,_genderPreference,_educationPreference;
  late bool _notifyPublications ,_notifyEmail,_notifyInteraction,_notifyWeekly,_notifyUpdates;


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
      UserProfile userProfile = await _apiService.fetchUserProfile(userName:profileController.authenticatedUser.value.username!);

      setState(() {
        _agePreference = maptoPrivacyPreference(userProfile.agePreference!);
        _genderPreference = maptoPrivacyPreference(userProfile.genderPreference!);
        _educationPreference = maptoPrivacyPreference(userProfile.educationPreference!);
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
        educationPreference: mapPrivacyPreferenceToString(_educationPreference!),
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
  @override
  Widget build(BuildContext context) {
    if(_isLoading){
      return Scaffold(backgroundColor: mainBackgroundColor,body: Center(child: CircularProgressIndicator(),),);
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
                        groupValue: _agePreference,
                        onChanged: (PrivacyPreference? value) {
                          setState(() {
                            _agePreference = value;
                          });
                        },
                        fillColor: MaterialStateColor.resolveWith((states) => Colors.purpleAccent),
                      ),
                    ),
                    ListTile(
                      title: const Text('friends',style: TextStyle(color: Colors.white),),
                      leading: Radio<PrivacyPreference>(
                        value: PrivacyPreference.friends,
                        groupValue: _agePreference,
                        onChanged: (PrivacyPreference? value) {
                          setState(() {
                            _agePreference = value;
                          });
                        },
                        fillColor: MaterialStateColor.resolveWith((states) => Colors.purpleAccent),
                      ),
                    ),
                    ListTile(
                      title: const Text('private',style: TextStyle(color: Colors.white),),
                      leading: Radio<PrivacyPreference>(
                        value: PrivacyPreference.private,
                        groupValue: _agePreference,
                        onChanged: (PrivacyPreference? value) {
                          setState(() {
                            _agePreference = value;
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
                        groupValue: _genderPreference,
                        onChanged: (PrivacyPreference? value) {
                          setState(() {
                            _genderPreference = value;
                          });
                        },
                        fillColor: MaterialStateColor.resolveWith((states) => Colors.purpleAccent),
                      ),
                    ),
                    ListTile(
                      title: const Text('friends',style: TextStyle(color: Colors.white),),
                      leading: Radio<PrivacyPreference>(
                        value: PrivacyPreference.friends,
                        groupValue: _genderPreference,
                        onChanged: (PrivacyPreference? value) {
                          setState(() {
                            _genderPreference = value;
                          });
                        },
                        fillColor: MaterialStateColor.resolveWith((states) => Colors.purpleAccent),
                      ),
                    ),
                    ListTile(
                      title: const Text('private',style: TextStyle(color: Colors.white),),
                      leading: Radio<PrivacyPreference>(
                        value: PrivacyPreference.private,
                        groupValue: _genderPreference,
                        onChanged: (PrivacyPreference? value) {
                          setState(() {
                            _genderPreference = value;
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
                        groupValue: _educationPreference,
                        onChanged: (PrivacyPreference? value) {
                          setState(() {
                            _educationPreference = value;
                          });
                        },
                        fillColor: MaterialStateColor.resolveWith((states) => Colors.purpleAccent),
                      ),
                    ),
                    ListTile(
                      title: const Text('friends',style: TextStyle(color: Colors.white),),
                      leading: Radio<PrivacyPreference>(
                        value: PrivacyPreference.friends,
                        groupValue: _educationPreference,
                        onChanged: (PrivacyPreference? value) {
                          setState(() {
                            _educationPreference = value;
                          });
                        },
                        fillColor: MaterialStateColor.resolveWith((states) => Colors.purpleAccent),
                      ),
                    ),
                    ListTile(
                      title: const Text('private',style: TextStyle(color: Colors.white),),
                      leading: Radio<PrivacyPreference>(
                        value: PrivacyPreference.private,
                        groupValue: _educationPreference,
                        onChanged: (PrivacyPreference? value) {
                          setState(() {
                            _educationPreference = value;
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
                  value: _notifyPublications,
                  onChanged: (bool newValue) {
                    setState(() {
                      _notifyPublications = newValue;
                    });
                  },
                ),
              ),
              SizedBox(height: 15,),
              Center(
                child: LabeledCheckbox(
                  label: ' Notification emails, receive emails when someone you follow publishes content.',
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  value: _notifyEmail,
                  onChanged: (bool newValue) {
                    setState(() {
                      _notifyEmail = newValue;
                    });
                  },
                ),
              ),
              SizedBox(height: 15,),
              Center(
                child: LabeledCheckbox(
                  label: ' Interaction emails: receive emails when someone comments on your content.',
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  value: _notifyInteraction,
                  onChanged: (bool newValue) {
                    setState(() {
                      _notifyInteraction = newValue;
                    });
                  },
                ),
              ),
              SizedBox(height: 15,),
              Center(
                child: LabeledCheckbox(
                  label: ' Weekly digest emails, receive emails about the week’s popular, recommended, editor’s picks, most reputable, and people’s choice articles.',
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  value: _notifyWeekly,
                  onChanged: (bool newValue) {
                    setState(() {
                      _notifyWeekly = newValue;
                    });
                  },
                ),
              ),
              SizedBox(height: 15,),
              Center(
                child: LabeledCheckbox(
                  label: 'Mindplex updates, receive timely company announcments and community updates.',
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  value: _notifyUpdates,
                  onChanged: (bool newValue) {
                    setState(() {
                      _notifyUpdates = newValue;
                    });
                  },
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: buildButton("Save", (() async {
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
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }).catchError((error) {
                    print('Error updating user profile: $error');
                  });
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
