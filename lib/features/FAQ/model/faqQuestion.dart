class FaqQuestion {
  String title;
  String slug;

  FaqQuestion({required this.title, required this.slug});

  FaqQuestion.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        slug = json["slug"] {}
}
