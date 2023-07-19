import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/popularModel.dart';

Future<List<PopularDetails>> getData() async {
  // String link =
  //     "https://newsapi.org/v2/top-headlines?country=in&apiKey=API_KEY";
  // var res = await rootBundle.loadString("assets/demoAPI.json");

  // String jsonsDataString = res.toString();

  // var data = json.decode(jsonsDataString);
  // print("json looooooooooooded ${data}");
  // list = data
  //     .map<PopularDetails>((json) => PopularDetails.fromJson(json))
  //     .toList();

  final jsondata = await rootBundle.loadString('assets/demoAPI.json');
  print("json value are loaded.............");
  final List<dynamic> populars = await jsonDecode(jsondata);
  print(".........................json value are loaded" + populars.toString());
  List<PopularDetails> popularDetail = [];
  populars.forEach((jsonCategory) {
    PopularDetails popularCategory = PopularDetails.fromJson(jsonCategory);
    popularDetail.add(popularCategory);
  });
  print("the length of the json is ${popularDetail.length}");
  return popularDetail;
}
