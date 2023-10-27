import 'dart:convert';

class UserProfile {
  String? firstName;
  String? lastName;
  String? avatarUrl;
  String? username;
  int? age;
  String? gender;
  int? recPopularity;
  int? recPattern;
  int? recQuality;
  int? recRandom;
  int? recTimeliness;
  String? agePreference;
  String? genderPreference;
  String? educationPreference;
  bool? notifyPublications;
  bool? notifyFollower;
  bool? notifyInteraction;
  bool? notifyWeekly;
  bool? notifyUpdates;
  String? biography;
  Education? education;
  List<String>? interests;
  SocialMedia? socialMedia;



  UserProfile({
    this.firstName,
    this.lastName,
    this.avatarUrl,
    this.username,
    this.age,
    this.gender,
    this.biography,
    this.education,
    this.interests,
    this.socialMedia,
    this.recPopularity,
    this.recPattern,
    this.recQuality,
    this.recRandom,
    this.recTimeliness,
    this.agePreference,
    this.genderPreference,
    this.educationPreference,
    this.notifyPublications,
    this.notifyFollower,
    this.notifyInteraction,
    this.notifyWeekly,
    this.notifyUpdates,
  });

  UserProfile.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    avatarUrl = json['avatar_url'];
    username = json['username'];
    age = json['age'];
    gender = json['gender'];
    recPopularity = json['rec_popularity'];
    recPattern = json['rec_pattern'];
    recQuality = json['rec_quality'];
    recRandom = json['rec_random'];
    recTimeliness = json['rec_timeliness'];
    agePreference = json['age_preference'];
    genderPreference = json['gender_preference'];
    educationPreference = json['education_preference'];
    notifyPublications = json['notify_publications'];
    notifyFollower = json['notify_follower'];
    notifyInteraction = json['notify_interaction'];
    notifyWeekly = json['notify_weekly'];
    notifyUpdates = json['notify_updates'];
    // Additional attributes
    biography = json['biography'];
    education = Education.fromJson(json['education']);
    interests = List<String>.from(json['interest']);
    socialMedia = SocialMedia.fromJson(jsonDecode(json['social_media']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['avatar_url'] = this.avatarUrl;
    data['username'] = this.username;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['rec_popularity'] = this.recPopularity;
    data['rec_pattern'] = this.recPattern;
    data['rec_quality'] = this.recQuality;
    data['rec_random'] = this.recRandom;
    data['rec_timeliness'] = this.recTimeliness;
    data['age_preference'] = this.agePreference;
    data['gender_preference'] = this.genderPreference;
    data['education_preference'] = this.educationPreference;
    data['notify_publications'] = this.notifyPublications;
    data['notify_follower'] = this.notifyFollower;
    data['notify_interaction'] = this.notifyInteraction;
    data['notify_weekly'] = this.notifyWeekly;
    data['notify_updates'] = this.notifyUpdates;
    return data;
  }
}

class Education {
  String id;
  String educationalBackground;

  Education({
    required this.id,
    required this.educationalBackground,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'],
      educationalBackground: json['educational_background'],
    );
  }
}

class SocialMedia {
  String link;

  SocialMedia({
    required this.link,
  });

  factory SocialMedia.fromJson(Map<String, dynamic> json) {
    return SocialMedia(
      link: json['github'],
    );
  }
}