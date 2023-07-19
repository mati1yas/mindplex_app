import 'package:flutter/material.dart';
import 'package:mindplex_app/models/popularModel.dart';

class PopularProvider with ChangeNotifier {
  List<PopularDetails> allPopularList = [];
  List<PopularDetails> get getAllPopularList => allPopularList;
  initPopularDetails(List<PopularDetails> details) {
    allPopularList = details;
    notifyListeners();
  }
}
