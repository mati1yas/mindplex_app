import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/search/controllers/search_controller.dart';

import '../../models/search_response.dart';

Widget categoryContainer(Category category) {
  SearchPageController searchPageController = Get.find();
  return Container(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  category.posts.toString() + "posts",
                  style: TextStyle(
                      fontWeight: FontWeight.w100,
                      color: Colors.white,
                      fontSize: 15),
                )
              ],
            ),
          ),
          InkWell(
            child: Icon(
              Icons.more_horiz,
              size: 22,
              color: Colors.white,
            ),
            onTap: () {},
          ),
        ],
      ),
    ),
  );
}