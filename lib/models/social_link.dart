class SocialLink {
  String? platform;
  String? link;

  SocialLink({this.platform, this.link});

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      platform: json.keys.first,
      link: json.values.first,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      platform!: link!,
    };
  }
}