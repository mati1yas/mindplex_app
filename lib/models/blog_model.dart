import 'package:get/get.dart';

class Blog {
  String? slug;
  String? url;
  String? postTypeFormat;
  String? thumbnailImage;
  String? authorUsername;
  String? authorAvatar;
  String? authorBio;
  String? mpxr;
  String? authorDisplayName;
  String? publishedAt;
  String? postTitle;
  String? overview;
  RxInt likes = 0.obs; // Changed to RxInt
  String? minToRead;
  List<Content>? content;
  RxBool isUserLiked = false.obs;
  RxBool isUserDisliked = false.obs;

  Blog({
    this.slug,
    this.url,
    this.postTypeFormat,
    this.thumbnailImage,
    this.authorUsername,
    this.authorAvatar,
    this.authorBio,
    this.mpxr,
    this.authorDisplayName,
    this.publishedAt,
    this.postTitle,
    this.overview,
    int? likes, // Changed to int
    this.minToRead,
    this.content,
    bool? userLiked,
    bool? userDisliked,
  }) {
    this.likes.value = likes ?? 0; // Initialize likes as an RxInt
    isUserLiked.value = userLiked ?? false;
    isUserDisliked.value = userDisliked ?? false;
  }

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      slug: json['slug'],
      url: json['url'],
      postTypeFormat: json['post_type_format'],
      thumbnailImage: json['thumbnail_image'],
      authorUsername: json['author_username'],
      authorAvatar: json['author_avatar'],
      authorBio: json['author_bio'],
      mpxr: json['mpxr'],
      authorDisplayName: json['author_display_name'],
      publishedAt: json['published_at'],
      postTitle: json['post_title'],
      overview: json['overview'],
      likes: json['likes'], // Changed to int
      minToRead: json['min_to_read'],
      content: (json['content'] as List<dynamic>?)
          ?.map((c) => Content.fromJson(c))
          .toList(),
      userLiked: json['is_user_liked'],
      userDisliked: json['is_user_disliked'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'slug': slug,
      'url': url,
      'post_type_format': postTypeFormat,
      'thumbnail_image': thumbnailImage,
      'author_username': authorUsername,
      'author_avatar': authorAvatar,
      'author_bio': authorBio,
      'mpxr': mpxr,
      'author_display_name': authorDisplayName,
      'published_at': publishedAt,
      'post_title': postTitle,
      'overview': overview,
      'likes': likes.value, // Access the value of RxInt
      'min_to_read': minToRead,
      'content': content?.map((c) => c.toJson()).toList(),
      'is_user_liked': isUserLiked.value,
      'is_user_disliked': isUserDisliked.value,
    };
    return data;
  }
}

class Content {
  String? type;
  String? content;

  Content({this.type, this.content});

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      type: json['type'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'type': type,
      'content': content,
    };
    return data;
  }
}
