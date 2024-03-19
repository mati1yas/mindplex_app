import 'package:mindplex/features/FAQ/model/faqQuestion.dart';

class FaqSubGroup {
  String name;
  String slug;
  List<FaqQuestion> faqQuestions = [];

  FaqSubGroup(
      {required this.name, required this.slug, required this.faqQuestions});
  FaqSubGroup.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        slug = json["slug"] {
    for (var item in json["questions"])
      faqQuestions.add(FaqQuestion.fromJson(item));
  }
}
