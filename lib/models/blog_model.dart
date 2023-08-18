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
  List<Content>? content;

  Blog({
    this.url,
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
    this.content,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      url: json['url'],
      postTypeFormat: json['post_type_format'],
      thumbnailImage: json['thumbnail_image'],
      authorUsername: json['author_username'],
      authorAvatar: json['author_avatar'],
      authorDisplayName: json['author_display_name'],
      publishedAt: json['published_at'],
      postTitle: json['post_title'],
      overview: json['overview'],
      likes: json['likes'],
      minToRead: json['min_to_read'],
      content: (json['content'] as List<dynamic>)
          .map((contentJson) => Content.fromJson(contentJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'url': url,
      'post_type_format': postTypeFormat,
      'thumbnail_image': thumbnailImage,
      'author_username': authorUsername,
      'author_avatar': authorAvatar,
      'author_display_name': authorDisplayName,
      'published_at': publishedAt,
      'post_title': postTitle,
      'overview': overview,
      'likes': likes,
      'min_to_read': minToRead,
    };
    if (content != null) {
      data['content'] = content!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Content {
  String? type;
  dynamic content;

  Content({this.type, this.content});

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      type: json['type'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'content': content,
    };
  }
}
