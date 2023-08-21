import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mindplex_app/profile/user_profile_controller.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() {
    return _BookmarkScreen();
  }
}

class _BookmarkScreen extends State<BookmarkScreen> {
  List _posts = [];

  Future<void> loadData() async {
    final String response =
        await rootBundle.loadString('assets/bookmarkAPI.json');
    final data = await json.decode(response);
    setState(() {
      _posts = data['items'];
      print('number of items: ${_posts.length}');
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  ProfileController profileController = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: _posts.length,
        separatorBuilder: (context, index) => SizedBox(height: 15),
        itemBuilder: (context, index) {
          var current = _posts[index];
          return Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xFF103e56),
            ),
            height: 250,
            width: 140,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  current['date'] ?? "",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  current['title'] ?? "",
                  style: TextStyle(
                    color: Color.fromARGB(255, 97, 255, 213),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: Text(
                  current['description'] ?? "",
                  style: TextStyle(color: Colors.white),
                )),
                Row(
                  children: [
                    Text(
                      current['lastseen'] ?? "",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      current['views'] ?? "",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }
}
