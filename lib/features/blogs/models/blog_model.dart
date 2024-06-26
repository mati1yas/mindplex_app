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
  List<Author>? authors;
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
      this.authors,
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

    if (json['authors'] != null) {
      authors = <Author>[];
      json['authors'].forEach((v) {
        authors!.add(new Author.fromJson(v));
      });
    }
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

    if (this.authors != null) {
      data['authors'] = this.authors!.map((v) => v.toJson()).toList();
    }
    data['author_display_name'] = this.authorDisplayName;
    data['is_following'] = this.isFollowing!.value;
    data['published_at'] = this.publishedAt;
    data['published_timestamp'] = this.publishedTimestamp;
    data['post_title'] = this.postTitle;
    data['overview'] = this.overview;
    data['likes'] = this.likes.value;
    data['comments'] = this.comments;
    data['views'] = this.views;
    data['min_to_read'] = this.minToRead;
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    data['is_user_liked'] = this.isUserLiked!.value;
    data['is_user_disliked'] = this.isUserDisliked!.value;
    data['is_bookmarked'] = this.isBookmarked!.value;
    data['is_votted'] = this.isVotted!.value;
    data['interacted_emoji'] = this.interactedEmoji!.value;
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

class Author {
  RxInt? userId = 0.obs;
  String? username;
  String? avatar;
  String? bio;
  String? displayName;
  RxBool? isFollowing = false.obs;
  Rx<dynamic>? mpxr = Rx<dynamic>(null);

  Author({
    int? userId,
    this.username,
    this.avatar,
    this.bio,
    this.displayName,
    bool? isFollowing,
  });

  Author.fromJson(Map<dynamic, dynamic> json) {
    userId = RxInt(json['user_id'].runtimeType == String
        ? int.tryParse(json['user_id']) ?? 0
        : json['user_id']);
    username = json['username'];
    avatar = json['avatar'];
    bio = json['bio'];
    displayName = json['display_name'];
    isFollowing = RxBool(json['is_following'] ?? false);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId!.value;
    data['username'] = this.username;
    data['avatar'] = this.avatar;
    data['bio'] = this.bio;
    data['display_name'] = this.displayName;
    data['is_following'] = this.isFollowing!.value;
    return data;
  }
}
