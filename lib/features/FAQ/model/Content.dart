class HtmlContent {
  String type;
  String content;

  HtmlContent({required this.type, required this.content});
  HtmlContent.fromJson(Map<String, dynamic> json)
      : type = json["type"],
        content = json["content"] {}
}
