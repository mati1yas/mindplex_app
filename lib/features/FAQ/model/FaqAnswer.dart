import 'package:mindplex/features/FAQ/model/Content.dart';

class FaqAnswer {
  String title;
  List<HtmlContent> contents = [];

  FaqAnswer({required this.title, required this.contents});

  FaqAnswer.fromJson(Map<String, dynamic> json) : title = json["post_title"] {
    for (var item in json["content"]) contents.add(HtmlContent.fromJson(item));
  }
}
