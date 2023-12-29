import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/user_profile_controller.dart';
import 'package:mindplex/utils/colors.dart';

class BookmarkScreen extends StatelessWidget {
  BookmarkScreen({super.key});

  ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Obx(() => profileController.isPostLoading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.separated(
                itemCount: profileController.publishedPosts.length,
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemBuilder: (context, index) {
                  var current = profileController.publishedPosts[index];
                  return Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      color: blogContainerColor,
                    ),
                    height: 250,
                    width: 140,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          current.publishedAt ?? "",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          current.postTitle ?? "",
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
                          current.overview ?? "",
                          style: TextStyle(color: Colors.white),
                        )),
                        Row(
                          children: [
                            Text(
                              current.minToRead ?? "",
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${current.views.toString()}k views" ?? "",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                })));
  }
}
