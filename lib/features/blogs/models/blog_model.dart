import 'package:get/get.dart';
import 'package:mindplex/features/blogs/models/reputation_model.dart';

class Blog {
  String? slug;
  String? url;
  String? postTypeFormat;
  String? thumbnailImage;
  String? banner;
  String? authorUsername;
  String? authorAvatar;
  String? authorBio;
  String? authorDisplayName;
  RxBool? isFollowing = false.obs;
  String? publishedAt;
  String? publishedTimestamp;
  String? postTitle;
  String? overview;
  RxInt likes = 0.obs;
  int? comments;
  int? views;
  String? minToRead;
  List<Content>? content;
  RxBool isUserLiked = false.obs;
  RxBool isUserDisliked = false.obs;
  RxBool? isBookmarked = false.obs;
  Rx<dynamic> isVotted = Rx<dynamic>(null);
  RxString interactedEmoji = ''.obs;

  Rx<Reputation?> reputation = Rx(null);

  Blog(
      {this.slug,
      this.url,
      this.postTypeFormat,
      this.thumbnailImage,
      this.banner,
      this.authorUsername,
      this.authorAvatar,
      this.authorBio,
      this.authorDisplayName,
      bool? isFollowing,
      this.publishedAt,
      this.publishedTimestamp,
      this.postTitle,
      this.overview,
      int? likes,
      this.comments,
      this.views,
      this.minToRead,
      this.content,
      bool? isUserLiked,
      bool? isUserDisliked,
      bool? isBookmarked,
      dynamic isVotted,
      String? interactedEmoji}) {
    this.isUserDisliked.value = isUserDisliked ?? false;
    this.isUserLiked.value = isUserLiked ?? false;
    this.likes.value = likes ?? 0;

    this.interactedEmoji.value = interactedEmoji ?? '';
  }

  Blog.fromJson(Map<String, dynamic> json) {
    slug = json['slug'];
    url = json['url'];
    postTypeFormat =
        json['post_type_format'] != "" ? json['post_type_format'] : "text";
    thumbnailImage = json['thumbnail_image'];
    banner = json['banner'];
    authorUsername = json['author_username'];
    authorAvatar = json['author_avatar'];
    authorBio = json['author_bio'];
    authorDisplayName = json['author_display_name'];
    isFollowing = RxBool(json['is_following']);
    publishedAt = json['published_at'];
    publishedTimestamp = json['published_timestamp'];
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
    interactedEmoji = RxString(json['interacted_emoji'] ?? "");

    isBookmarked = RxBool(json['is_bookmarked']);
    isVotted = Rx<dynamic>(json['is_votted']);
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
    data['author_display_name'] = this.authorDisplayName;
    data['is_following'] = this.isFollowing;
    data['published_at'] = this.publishedAt;
    data['published_timestamp'] = this.publishedTimestamp;
    data['post_title'] = this.postTitle;
    data['overview'] = this.overview;
    data['likes'] = this.likes;
    data['comments'] = this.comments;
    data['views'] = this.views;
    data['min_to_read'] = this.minToRead;
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    data['is_user_liked'] = this.isUserLiked;
    data['is_user_disliked'] = this.isUserDisliked;
    data['is_bookmarked'] = this.isBookmarked;
    data['is_votted'] = this.isVotted;
    data['interacted_emoji'] = this.interactedEmoji;
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
