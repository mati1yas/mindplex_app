import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/search/controllers/search_controller.dart';
import 'package:mindplex/utils/number_coverter.dart';

import '../../models/search_response.dart';

Widget categoryContainer(
    {required Category category,
    required TextEditingController searchTextEditingController,
    required int index}) {
  SearchPageController searchPageController = Get.find();
  return GestureDetector(
    onTap: () {
      searchPageController.isSearchResultPage.value = true;
      searchTextEditingController.text =
          searchPageController.categories[index].slug;
      searchPageController
          .fetchSearchResults(searchPageController.categories[index].slug);
    },
    child: Container(
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
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    formatNumber(category.posts) + " posts",
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
    ),
  );
}
