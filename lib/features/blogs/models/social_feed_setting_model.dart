class SocialFeedSetting {
  String? initialMpxr;
  String? timeBetweenPost;
  String? timeBeforeDeletion;
  String? minRequiredMpxr;

  SocialFeedSetting(
      {this.initialMpxr,
      this.timeBetweenPost,
      this.timeBeforeDeletion,
      this.minRequiredMpxr});

  SocialFeedSetting.fromJson(Map<String, dynamic> json) {
    initialMpxr = json['initial_mpxr'];
    timeBetweenPost = json['next_post_time'].toString();
    timeBeforeDeletion = json['check_for_mpxr_to_pass'];
    minRequiredMpxr = json['min_mpxr_to_pass'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['initial_mpxr'] = this.initialMpxr;
    data['TimeBetweenPost'] = this.timeBetweenPost;
    data['timeBeforeDeletion'] = this.timeBeforeDeletion;
    data['minRequiredMpxr'] = this.minRequiredMpxr;
    return data;
  }
}
