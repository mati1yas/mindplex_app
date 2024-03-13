import 'dart:convert';

import 'package:flutter/material.dart';

import 'FaqList.dart';

class FaqGroupModel {
  String title;
  List<FaqListModel> faqLists;
  Icon icon;
  int id;

  FaqGroupModel(
      {required this.title,
      required this.faqLists,
      required this.id,
      required this.icon});

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
