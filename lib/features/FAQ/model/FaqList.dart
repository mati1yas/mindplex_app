import 'dart:convert';

import 'package:mindplex/features/FAQ/model/faqModel.dart';

class FaqListModel {
  String title;
  List<Faq> faqs;
  int id;

  FaqListModel({required this.title, required this.faqs, required this.id});

  // Faq.fromJson(Map<String, dynamic> json)
  //     : title = json["title"],
  //       answer = json['answer'],
  //       id = json['id'];

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['question'] = this.question;
  //   data['answer'] = this.answer;
  //   data['id'] = this.id;
  //   return data;
  // }
}
