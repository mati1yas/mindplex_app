class HtmlContent {
  String type;
  dynamic content;

  HtmlContent({required this.type, required this.content});
  HtmlContent.fromJson(Map<String, dynamic> json) : type = json["type"] {
    if (json["content"] is String) {
      content = json["content"];
    } else {
      content = [];
      for (var row in json["content"]) {
        var arrRow = [];
        for (var str in row) {
          arrRow.add(str);
        }
        content.add(arrRow);
      }
    }
  }
}
