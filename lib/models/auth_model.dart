class AuthModel {
  String? token;
  String? userEmail;
  String? userNicename;
  String? userDisplayName;
  String? username;
  String? firstName;
  String? lastName;
  String? image;

  AuthModel(
      {this.token,
      this.userEmail,
      this.userNicename,
      this.userDisplayName,
      this.username,
      this.firstName,
      this.lastName,
      this.image});

  AuthModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    userEmail = json['user_email'];
    userNicename = json['user_nicename'];
    userDisplayName = json['user_display_name'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['user_email'] = this.userEmail;
    data['user_nicename'] = this.userNicename;
    data['user_display_name'] = this.userDisplayName;
    data['username'] = this.username;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['image'] = this.image;
    return data;
  }
}
