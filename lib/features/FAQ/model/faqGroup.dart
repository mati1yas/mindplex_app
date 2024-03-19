import 'package:mindplex/features/FAQ/model/FaqSubGroup.dart';

class FaqGroup {
  String name;
  String slug;
  List<FaqSubGroup> sub = [];

  FaqGroup({required this.name, required this.slug, required this.sub});

  FaqGroup.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        slug = json["slug"] {
    for (var item in json["sub"]) sub.add(FaqSubGroup.fromJson(item));
  }
}
