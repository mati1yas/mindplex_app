import 'package:mindplex_app/models/user_profile.dart';

import 'blog_model.dart';

class SearchResponseLanding{

  List<Category>? categories;
  List<Blog>? blogs;
}

class Category {
  String name;
  String slug;
  int posts;

  Category({
    required this.name,
    required this.slug,
    required this.posts,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      slug: json['slug'],
      posts: json['posts'],
    );
  }
}

class SearchResponse{
  List<UserProfile>? users;
  List<Blog>? blogs;
}