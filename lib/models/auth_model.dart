class AuthModel {
  String? token;
  String? userEmail;
  String? userNicename;
  String? userDisplayName;
  String? biography;
  String? username;
  String? firstName;
  String? lastName;
  String? image;
  int? followings;
  int? followers;
  int? friends;

  AuthModel(
      {this.token,
      this.userEmail,
      this.userNicename,
      this.userDisplayName,
      this.biography,
      this.username,
      this.firstName,
      this.lastName,
      this.image,
      this.followings,
      this.followers,
      this.friends});

  AuthModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    userEmail = json['user_email'];
    userNicename = json['user_nicename'];
    userDisplayName = json['user_display_name'];
    biography = json['biography'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    image = json['image'];
    followings = json['followings'];
    followers = json['followers'];
    friends = json['friends'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['user_email'] = this.userEmail;
    data['user_nicename'] = this.userNicename;
    data['user_display_name'] = this.userDisplayName;
    data['biography'] = this.biography;
    data['username'] = this.username;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['image'] = this.image;
    data['followings'] = this.followings;
    data['followers'] = this.followers;
    data['friends'] = this.friends;
    return data;
  }
}
