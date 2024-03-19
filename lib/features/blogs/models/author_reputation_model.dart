class AuthorReputation {
  int? user;
  double? mpxr;

  AuthorReputation({this.user, this.mpxr});

  AuthorReputation.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    mpxr = json['mpxr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['mpxr'] = this.mpxr;
    return data;
  }
}
