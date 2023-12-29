class NotificationModel {
  String? firstName;
  String? lastName;
  String? username;
  String? avatar;
  String? interactedAt;
  String? type;
  bool? seen;
  String? postType;
  String? serviceId;
  String? message;

  NotificationModel(
      {this.firstName,
      this.lastName,
      this.username,
      this.avatar,
      this.interactedAt,
      this.type,
      this.seen,
      this.postType,
      this.serviceId,
      this.message});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    avatar = json['avatar'];
    interactedAt = json['interacted_at'];
    type = json['type'];
    seen = json['seen'];
    postType = json['post_type'];
    serviceId = json['service_id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['username'] = this.username;
    data['avatar'] = this.avatar;
    data['interacted_at'] = this.interactedAt;
    data['type'] = this.type;
    data['seen'] = this.seen;
    data['post_type'] = this.postType;
    data['service_id'] = this.serviceId;
    data['message'] = this.message;
    return data;
  }
}
