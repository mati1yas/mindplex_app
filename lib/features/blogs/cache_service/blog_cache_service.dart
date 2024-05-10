import 'package:mindplex/features/blogs/models/blog_model.dart';

class BlogCacheService {
  Map<String, dynamic> _cache = {};

  dynamic getFromCache(String key) {
    final List<dynamic> jsonData = _cache[key];
    final List<Blog> blogs =
        jsonData.map((json) => Blog.fromJson(json)).toList();

    return blogs;
  }

  void addToCache(String key, List<Blog> data) {
    final jsonData = data.map((model) => model.toJson()).toList();
    if (isInCache(key)) {
      _cache[key].addAll(jsonData);
    } else {
      _cache[key] = jsonData;
    }
  }

  bool isInCache(String key) {
    return _cache.containsKey(key);
  }

  void removeFromCache(String key) {
    _cache.remove(key);
  }
}
