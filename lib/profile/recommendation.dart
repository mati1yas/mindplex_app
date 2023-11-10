import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mindplex_app/profile/user_profile_controller.dart';

import '../models/user_profile.dart';
import '../routes/app_routes.dart';
import '../services/api_services.dart';
import '../utils/colors.dart';

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({Key? key}) : super(key: key);

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}
late List<int> editedSeekbars;
late int lastEditedSeekbar;
class _RecommendationPageState extends State<RecommendationPage> {
  late double _popularitySliderValue;
  late double _patternSliderValue;
  late double _highQualitySliderValue;
  late double _randomSliderValue;
  late double _timelinessSliderValue;

  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    editedSeekbars = [];
    lastEditedSeekbar = 0;

  }

  Future<void> fetchUserProfile() async {
    setState(() {
      _isLoading = true;
    });
    ProfileController profileController = Get.put(ProfileController());

    try {
      UserProfile userProfile = await _apiService.fetchUserProfile(userName:profileController.authenticatedUser.value.username!);

      setState(() {
        _popularitySliderValue = userProfile.recPopularity!.toDouble();
        _patternSliderValue = userProfile.recPattern!.toDouble();
        _highQualitySliderValue = userProfile.recQuality!.toDouble();
        _randomSliderValue = userProfile.recRandom!.toDouble();
        _timelinessSliderValue = userProfile.recTimeliness!.toDouble();
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
    if(await checkSeekBarValues() == false) {
      Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
        titleSize: 20,
        messageSize: 17,
        messageColor: Colors.white,
        backgroundColor: Colors.red,
        borderRadius: BorderRadius.circular(8),
        message: "Sum of Recommendation values must be below 100",
        duration: const Duration(seconds: 2),
      ).show(context);
    }
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
      UserProfile updatedProfile = UserProfile(
        // Set the updated values for the profile properties
        recPopularity: _popularitySliderValue.round(),
        recPattern: _patternSliderValue.round(),
        recQuality: _highQualitySliderValue.round(),
        recRandom: _randomSliderValue.round(),
        recTimeliness: _timelinessSliderValue.round(),
      );
      String? updatedValues = await _apiService.updateUserProfile(
        updatedProfile: updatedProfile,
      );
      print(updatedValues);
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
        message: "Saved",
        duration: const Duration(seconds: 2),
      ).show(context);
      return updatedValues;
    } catch (e) {
      setState(() {
        _isUpdating = false;
      });
      print('Error updating user profile: $e');
      return '';
    }
  }

  void updateSeekBarValue(int seekBarIndex, double newValue) {
    setState(() {
      double totalAmount = 0;
      for(int i = 0;i<editedSeekbars.length;i++){
        if(editedSeekbars[i] == seekBarIndex){
          continue;
        }
        totalAmount +=getSeekBarValue(editedSeekbars[i]);
      }
      double remainingAmount = 100 - totalAmount - newValue;
      int length = 0;
      if(editedSeekbars.contains(seekBarIndex)&& lastEditedSeekbar ==seekBarIndex){
        length = editedSeekbars.length- 1;
      }
      else{
        length = editedSeekbars.length;
      }
      double newValueForOthers = remainingAmount / (4 - length);
      if(newValueForOthers>0|| newValueForOthers <100) {
        lastEditedSeekbar = seekBarIndex;
        if(!editedSeekbars.contains(seekBarIndex)) {
          editedSeekbars.add(seekBarIndex);
        }
        for (int i = 1; i < 6; i++) {
          if (i != seekBarIndex && !editedSeekbars.contains(i)) {
            setSeekBarValue(i, newValueForOthers);
          }
        }
        setSeekBarValue(seekBarIndex, newValue);
      }
      _popularitySliderValue = _popularitySliderValue.clamp(0, 100);
      _patternSliderValue = _patternSliderValue.clamp(0, 100);
      _highQualitySliderValue = _highQualitySliderValue.clamp(0, 100);
      _randomSliderValue = _randomSliderValue.clamp(0, 100);
      _timelinessSliderValue = _timelinessSliderValue.clamp(0, 100);
    });

  }

  double getSeekBarValue(int seekBarIndex) {
    switch (seekBarIndex) {
      case 1:
        return _popularitySliderValue;
      case 2:
        return _patternSliderValue;
      case 3:
        return _highQualitySliderValue;
      case 4:
        return _randomSliderValue;
      case 5:
        return _timelinessSliderValue;
      default:
        return 0;
    }
  }

  void setSeekBarValue(int seekBarIndex, double value) {
    switch (seekBarIndex) {
      case 1:
        setState(() {
          _popularitySliderValue = value;
        });
        break;
      case 2:
        setState(() {
          _patternSliderValue = value;
        });
        break;
      case 3:
        setState(() {
          _highQualitySliderValue = value;
        });
        break;
      case 4:
        setState(() {
          _randomSliderValue = value;
        });
        break;
      case 5:
        setState(() {
          _timelinessSliderValue = value;
        });
        break;
    }
  }

  Future<bool> checkSeekBarValues() async{
    int totalValues = 0;
    for(int i = 1;i<6;i++){
      totalValues +=getSeekBarValue(i).round();
    }
    print(totalValues);
    if(totalValues == 100){
      return true;
    }
    else if(totalValues == 99){
      setState(() {
        _popularitySliderValue +=0.5;
      });
      return checkSeekBarValues();
    }
    else if(totalValues == 101){
      setState(() {
        _popularitySliderValue -=0.5;
      });
      return checkSeekBarValues();
    }
    else if(totalValues == 102){
      setState(() {
        _popularitySliderValue -=1;
      });
      return checkSeekBarValues();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(backgroundColor: mainBackgroundColor,
      body: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),);
    }
    return Scaffold(
        backgroundColor: mainBackgroundColor,
        body: SingleChildScrollView(
        child: Column(children: [
          Container(child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Here, you can set the intensity of our recommendation engine's parameters. "
                "Mindplex empowers you to own your own model, and we recommend content based on a model of your choice. "
                "Edit your model here, and enjoy our content from the read pages." , textAlign: TextAlign.justify,style: TextStyle(color: Colors.white,fontSize: 15),),
          ),),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left:16.0, top: 10),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Popularity",
                    style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.w800,
                        fontSize: 20
                    ),
                  ),
                ),
              ),
              Slider(
                value: editedSeekbars.isEmpty&&_popularitySliderValue == 0.0?50.0:_popularitySliderValue,
                max: 100,
                divisions: 100,
                label: _popularitySliderValue.round().toString(),
                onChanged: (newValue) => updateSeekBarValue(1, newValue),
              ),
             Center(child: Text((editedSeekbars.isEmpty&&_popularitySliderValue == 0.0?" ":_popularitySliderValue.round().toString())+"%",style: TextStyle(
                 color: Colors.amber,
                 fontWeight: FontWeight.w500,
                 fontSize: 20),)
             ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left:16.0, top: 10),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Pattern",
                    style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.w800,
                        fontSize: 20
                    ),
                  ),
                ),
              ),
              Slider(
                value: editedSeekbars.isEmpty&&_patternSliderValue == 0.0?50.0:_patternSliderValue,
                max: 100,
                divisions: 100,
                label: _patternSliderValue.round().toString(),
                onChanged: (newValue) => updateSeekBarValue(2, newValue),
              ),
              Center(child: Text((editedSeekbars.isEmpty&&_patternSliderValue == 0.0?" ":_patternSliderValue.round().toString().toString())+"%",style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),)
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left:16.0, top: 10),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "High Quality",
                    style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.w800,
                        fontSize: 20
                    ),
                  ),
                ),
              ),
              Slider(
                value: editedSeekbars.isEmpty&&_highQualitySliderValue == 0.0?50.0:_highQualitySliderValue,
                max: 100,
                divisions: 100,
                label: _highQualitySliderValue.round().toString(),
                onChanged: (newValue) => updateSeekBarValue(3, newValue),
              ),
              Center(child: Text((editedSeekbars.isEmpty&&_highQualitySliderValue == 0.0?" ":_highQualitySliderValue.round().toString())+"%",style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),)
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left:16.0, top: 10),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Random",
                    style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.w800,
                        fontSize: 20
                    ),
                  ),
                ),
              ),
              Slider(
                value: editedSeekbars.isEmpty&&_randomSliderValue == 0.0?50.0:_randomSliderValue,
                max: 100,
                divisions: 100,
                label: _randomSliderValue.round().toString(),
                onChanged: (newValue) => updateSeekBarValue(4, newValue),
              ),
              Center(child: Text((editedSeekbars.isEmpty&&_randomSliderValue == 0.0?"":_randomSliderValue.round().toString())+"%",style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),)
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left:16.0, top: 10),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Timeliness",
                    style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.w800,
                        fontSize: 20
                    ),
                  ),
                ),
              ),
              Slider(
                value: editedSeekbars.isEmpty&&_timelinessSliderValue == 0.0?50.0:_timelinessSliderValue!,
                max: 100,
                divisions: 100,
                label: _timelinessSliderValue.round().toString(),
                onChanged: (newValue) => updateSeekBarValue(5, newValue),
              ),
              Center(child: Text((editedSeekbars.isEmpty&&_timelinessSliderValue == 0.0?" ":_timelinessSliderValue.round().toString())+"%",style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),)
              ),
              SizedBox(height: 10,)
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: buildButton("Save", (() async {
                updateUserProfile().then((String updatedValues) {
                  print('Updated values: $updatedValues');
                }).catchError((error) {
                  print('Error updating user profile: $error');
                });
            }), const Color(0xFFF400D7), const Color(0xFFFF00D7)),
          ),],),),);
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
}
