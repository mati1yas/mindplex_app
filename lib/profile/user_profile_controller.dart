import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mindplex_app/models/auth_model.dart';
import 'package:mindplex_app/services/local_storage.dart';

import '../models/popularModel.dart';
import 'about_screen.dart';
import 'bookmark_screen.dart';

class ProfileController extends GetxController {
  Rx<AuthModel> authenticatedUser = Rx<AuthModel>(AuthModel());
  RxString selectedTabCategory = "About".obs;
  RxBool isLoading = true.obs;
  RxString selectedBlogCategory = "Popular".obs;
  RxList<PopularDetails> blogs = <PopularDetails>[].obs;

  var screens = [
    {'name': 'About', 'active': true, 'widget': const AboutScreen(), "num": 1},
    {
      'name': 'Published Content',
      "active": false,
      'widget': const BookmarkScreen(),
      "num": 2
    },
    {
      'name': 'Bookmarks',
      "active": false,
      'widget': const BookmarkScreen(),
      "num": 2
    },
    {
      'name': 'Drafts',
      "active": false,
      'widget': const BookmarkScreen(),
      "num": 2
    }
  ];

  @override
  void onInit() {
    super.onInit();
    fetchBlogs();
  }

  void switchTab({required String tab}) {
    selectedTabCategory.value = tab;
  }

  final localStorage =
      LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
  Future<void> getAuthenticatedUser() async {
    authenticatedUser.value = await localStorage.value.readUserInfo();
  }

  void fetchBlogs() async {
    final jsondata = await rootBundle.loadString('assets/demoAPI.json');

    final List<dynamic> populars = await jsonDecode(jsondata);

    List<PopularDetails> popularDetail = [];
    populars.forEach((jsonCategory) {
      PopularDetails popularCategory = PopularDetails.fromJson(jsonCategory);
      popularDetail.add(popularCategory);
    });

    blogs.value = popularDetail;
    isLoading.value = false;
  }

  void filterBlogsByCategory({required String category}) {
    selectedBlogCategory.value = category;
  }

  List<PopularDetails> get filteredBlogs {
    return blogs
        .where((blog) => blog.type == selectedBlogCategory.value)
        .toList();
  }
}
