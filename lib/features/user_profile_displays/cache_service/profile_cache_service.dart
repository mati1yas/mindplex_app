import 'package:mindplex/features/blogs/models/blog_model.dart';
import 'package:mindplex/features/user_profile_settings/models/user_profile.dart';

class ProfileCacheService {
  Map<String, dynamic> _cache = {};

  dynamic getFromCache(String key) {
    final dynamic jsonData = _cache[key];
    final UserProfile userProfile = UserProfile.fromJson(jsonData);

    return userProfile;
  }

  void addToCache(String key, UserProfile data) {
    final jsonData = data.toJson();

    _cache[key] = jsonData;
  }

  bool isInCache(String key) {
    return _cache.containsKey(key);
  }

  void removeFromCache(String key) {
    _cache.remove(key);
  }
}
