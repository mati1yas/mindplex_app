import 'package:get/get.dart';

class FollowerModel {
  String? username;
  String? displayName;
  String? avatarUrl;
  RxBool? isFollowing = false.obs;
  String? isFriends;

  FollowerModel(
      {this.username,
      this.displayName,
      this.avatarUrl,
      this.isFollowing,
      this.isFriends});

  FollowerModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    displayName = json['display_name'];
    avatarUrl = json['avatar_url'];
    isFollowing = RxBool(json['is_following'] ?? false);
    isFriends = json['is_friends'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['display_name'] = this.displayName;
    data['avatar_url'] = this.avatarUrl;
    data['is_following'] = this.isFollowing!.value;
    data['is_friends'] = this.isFriends;
    return data;
  }
}
