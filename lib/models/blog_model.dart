class Blog {
  String? url;
  String? postTypeFormat;
  String? thumbnailImage;
  String? authorUsername;
  String? authorAvatar;
  String? authorDisplayName;
  String? publishedAt;
  String? postTitle;
  String? overview;
  int? likes;
  String? minToRead;
  String? content;

  Blog(
      {this.url,
      this.postTypeFormat,
      this.thumbnailImage,
      this.authorUsername,
      this.authorAvatar,
      this.authorDisplayName,
      this.publishedAt,
      this.postTitle,
      this.overview,
      this.likes,
      this.minToRead,
      this.content});

  Blog.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    postTypeFormat = json['post_type_format'];
    thumbnailImage = json['thumbnail_image'];
    authorUsername = json['author_username'];
    authorAvatar = json['author_avatar'];
    authorDisplayName = json['author_display_name'];
    publishedAt = json['published_at'];
    postTitle = json['post_title'];
    overview = json['overview'];
    likes = json['likes'];
    minToRead = json['min_to_read'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['post_type_format'] = this.postTypeFormat;
    data['thumbnail_image'] = this.thumbnailImage;
    data['author_username'] = this.authorUsername;
    data['author_avatar'] = this.authorAvatar;
    data['author_display_name'] = this.authorDisplayName;
    data['published_at'] = this.publishedAt;
    data['post_title'] = this.postTitle;
    data['overview'] = this.overview;
    data['likes'] = this.likes;
    data['min_to_read'] = this.minToRead;
    data['content'] = this.content;
    return data;
  }
}
