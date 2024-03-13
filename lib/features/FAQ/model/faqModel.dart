import 'dart:convert';

class Faq {
  String question;
  String answer;
  int id;

  Faq({required this.question, required this.answer, required this.id});

  Faq.fromJson(Map<String, dynamic> json)
      : question = json['question'],
        answer = json['answer'],
        id = json['id'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = this.question;
    data['answer'] = this.answer;
    data['id'] = this.id;
    return data;
  }
}
