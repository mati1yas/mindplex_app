import 'package:get/get.dart';

class Blog {
  String? slug;
  String? url;
  String? postTypeFormat;
  String? thumbnailImage;
  String? banner;
  String? authorUsername;
  String? authorAvatar;
  String? authorBio;
  String? mpxr;
  String? authorDisplayName;
  String? publishedAt;
  String? postTitle;
  String? overview;
  RxInt likes = 0.obs;
  int? comments;
  int? views;
  String? minToRead;
  List<Content>? content;
  RxBool isUserLiked = false.obs;
  RxBool isUserDisliked = false.obs;

  RxString interactedEmoji = ''.obs;

  Blog(
      {this.slug,
      this.url,
      this.postTypeFormat,
      this.thumbnailImage,
      this.banner,
      this.authorUsername,
      this.authorAvatar,
      this.authorBio,
      this.mpxr,
      this.authorDisplayName,
      this.publishedAt,
      this.postTitle,
      this.overview,
      int? likes,
      this.comments,
      this.views,
      this.minToRead,
      this.content,
      bool? isUserLiked,
      bool? isUserDisliked,
      String? interactedEmoji}) {
    this.isUserDisliked.value = isUserDisliked ?? false;
    this.isUserLiked.value = isUserLiked ?? false;
    this.likes.value = likes ?? 0;
    this.interactedEmoji.value = interactedEmoji ?? '';
  }

  Blog.fromJson(Map<String, dynamic> json) {
    slug = json['slug'];
    url = json['url'];
    postTypeFormat = json['post_type_format'];
    thumbnailImage = json['thumbnail_image'];
    banner = json['banner'];
    authorUsername = json['author_username'];
    authorAvatar = json['author_avatar'];
    authorBio = json['author_bio'];
    mpxr = json['mpxr'];
    authorDisplayName = json['author_display_name'];
    publishedAt = json['published_at'];
    postTitle = json['post_title'];
    overview = json['overview'];
    likes = RxInt(json['likes']);
    comments = json['comments'];
    views = json['views'];
    minToRead = json['min_to_read'];
    if (json['content'] != null) {
      content = <Content>[];
      json['content'].forEach((v) {
        content!.add(new Content.fromJson(v));
      });
    }
    isUserLiked = RxBool(json['is_user_liked']);
    isUserDisliked = RxBool(json['is_user_disliked']);
    interactedEmoji = RxString(json['interacted_emoji']??"");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slug'] = this.slug;
    data['url'] = this.url;
    data['post_type_format'] = this.postTypeFormat;
    data['thumbnail_image'] = this.thumbnailImage;
    data['banner'] = this.banner;
    data['author_username'] = this.authorUsername;
    data['author_avatar'] = this.authorAvatar;
    data['author_bio'] = this.authorBio;
    data['mpxr'] = this.mpxr;
    data['author_display_name'] = this.authorDisplayName;
    data['published_at'] = this.publishedAt;
    data['post_title'] = this.postTitle;
    data['overview'] = this.overview;
    data['likes'] = this.likes.value;
    data['comments'] = this.comments;
    data['views'] = this.views;
    data['min_to_read'] = this.minToRead;
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    data['is_user_liked'] = this.isUserLiked.value;
    data['is_user_disliked'] = this.isUserDisliked.value;
    data['interacted_emoji'] = this.interactedEmoji.value;
    return data;
  }
}

class Content {
  String? type;
  dynamic? content;

  Content({this.type, this.content});

  Content.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['content'] = this.content;
    return data;
  }
}

// class Blog {
//   String? slug;
//   String? url;
//   String? postTypeFormat;
//   String? thumbnailImage;
//   String? authorUsername;
//   String? authorAvatar;
//   String? authorBio;
//   String? mpxr;
//   String? authorDisplayName;
//   String? publishedAt;
//   String? postTitle;
//   String? banner;
//   String? overview;
//   RxInt likes = 0.obs; // Changed to RxInt
//   String? minToRead;
//   List<Content>? content;
//   RxBool isUserLiked = false.obs;
//   RxBool isUserDisliked = false.obs;

//   Blog({
//     this.slug,
//     this.url,
//     this.postTypeFormat,
//     this.thumbnailImage,
//     this.authorUsername,
//     this.authorAvatar,
//     this.authorBio,
//     this.mpxr,
//     this.authorDisplayName,
//     this.publishedAt,
//     this.postTitle,
//     this.banner,
//     this.overview,
//     int? likes, // Changed to int
//     this.minToRead,
//     this.content,
//     bool? userLiked,
//     bool? userDisliked,
//   }) {
//     this.likes.value = likes ?? 0; // Initialize likes as an RxInt
//     isUserLiked.value = userLiked ?? false;
//     isUserDisliked.value = userDisliked ?? false;
//   }

//   factory Blog.fromJson(Map<String, dynamic> json) {
//     return Blog(
//       slug: json['slug'],
//       url: json['url'],
//       postTypeFormat: json['post_type_format'],
//       thumbnailImage: json['thumbnail_image'],
//       authorUsername: json['author_username'],
//       authorAvatar: json['author_avatar'],
//       authorBio: json['author_bio'],
//       mpxr: json['mpxr'],
//       authorDisplayName: json['author_display_name'],
//       publishedAt: json['published_at'],
//       postTitle: json['post_title'],
//       banner: json['banner'],
//       overview: json['overview'],
//       likes: json['likes'], // Changed to int
//       minToRead: json['min_to_read'],
//       content: (json['content'] as List<dynamic>?)
//           ?.map((c) => Content.fromJson(c))
//           .toList(),
//       userLiked: json['is_user_liked'],
//       userDisliked: json['is_user_disliked'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {
//       'slug': slug,
//       'url': url,
//       'post_type_format': postTypeFormat,
//       'thumbnail_image': thumbnailImage,
//       'author_username': authorUsername,
//       'author_avatar': authorAvatar,
//       'author_bio': authorBio,
//       'mpxr': mpxr,
//       'author_display_name': authorDisplayName,
//       'published_at': publishedAt,
//       'post_title': postTitle,
//       'banner': banner,
//       'overview': overview,
//       'likes': likes.value, // Access the value of RxInt
//       'min_to_read': minToRead,
//       'content': content?.map((c) => c.toJson()).toList(),
//       'is_user_liked': isUserLiked.value,
//       'is_user_disliked': isUserDisliked.value,
//     };
//     return data;
//   }
// }

// class Content {
//   String? type;
//   String? content;

//   Content({this.type, this.content});

//   factory Content.fromJson(Map<String, dynamic> json) {
//     return Content(
//       type: json['type'],
//       content: json['content'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {
//       'type': type,
//       'content': content,
//     };
//     return data;
//   }
// }
