class Reputation {
  Author? author;
  double? postRep;
  String? postSlug;
  List<Editor>? editor;

  Reputation({this.author, this.postRep, this.postSlug, this.editor});

  Reputation.fromJson(Map<String, dynamic> json) {
    author =
        json['author'] != null ? new Author.fromJson(json['author']) : null;
    postRep = json['post_rep'].toDouble();
    postSlug = json['post_slug'];
    if (json['editor'] != null) {
      editor = <Editor>[];
      json['editor'].forEach((v) {
        editor!.add(new Editor.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.author != null) {
      data['author'] = this.author!.toJson();
    }
    data['post_rep'] = this.postRep;
    data['post_slug'] = this.postSlug;
    if (this.editor != null) {
      data['editor'] = this.editor!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Author {
  int? user;
  double? mpxr;

  Author({this.user, this.mpxr});

  Author.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    mpxr = json['mpxr'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['mpxr'] = this.mpxr;
    return data;
  }
}

class Editor {
  int? user;
  double? mpxr;

  Editor({this.user, this.mpxr});

  Editor.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    mpxr = json['mpxr'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['mpxr'] = this.mpxr;
    return data;
  }
}
