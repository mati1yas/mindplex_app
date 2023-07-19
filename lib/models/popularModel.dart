import 'dart:core';

class PopularDetails {
  int? id;
  String? type;
  String? profileName;
  String? MPXR;
  String? title;
  String? description;
  String? lastSeen;
  String? state;
  String? views;
  PopularDetails(
      {this.id,
      required this.type,
      required this.profileName,
      required this.MPXR,
      required this.description,
      required this.title,
      required this.lastSeen,
      required this.state,
      required this.views});
  factory PopularDetails.fromJson(Map<String, dynamic> json) {
    return PopularDetails(
        type: json["type"],
        profileName: json["profileName"],
        MPXR: json["MPXR"],
        description: json["description"],
        title: json["title"],
        lastSeen: json["lastSeen"],
        state: json["state"],
        views: json["views"]);
  }
}
