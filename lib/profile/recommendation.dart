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

class _RecommendationPageState extends State<RecommendationPage> {
  late double _popularitySliderValue;
  late double _patternSliderValue;
  late double _highQualitySliderValue;
  late double _randomSliderValue;
  late double _timelinessSliderValue;

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
    Text('Recommendation', textAlign: TextAlign.end, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white)),
    const SizedBox(width: 35)
    ],
    ),
    ),
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
                value: _popularitySliderValue == 0.0?50.0:_popularitySliderValue,
                max: 100,
                divisions: 100,
                label: _popularitySliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _popularitySliderValue = value;
                  });
                },
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
                value: _patternSliderValue == 0.0?50.0:_patternSliderValue,
                max: 100,
                divisions: 100,
                label: _patternSliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _patternSliderValue = value;
                  });
                },
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
                value: _highQualitySliderValue == 0.0?50.0:_highQualitySliderValue,
                max: 100,
                divisions: 100,
                label: _highQualitySliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _highQualitySliderValue = value;
                  });
                },
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
                value: _randomSliderValue == 0.0?50.0:_randomSliderValue,
                max: 100,
                divisions: 100,
                label: _randomSliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _randomSliderValue = value;
                  });
                },
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
                value: _timelinessSliderValue == 0.0?50.0:_timelinessSliderValue!,
                max: 100,
                divisions: 100,
                label: _timelinessSliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _timelinessSliderValue = value;
                  });
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: buildButton("Save", (() async {
              print(_popularitySliderValue.toString() +" and " + _highQualitySliderValue.toString() );
            }), const Color(0xFFF400D7), const Color(0xFFFF00D7)),
          ),],),),);
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
}