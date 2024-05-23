import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/FAQ/controller/faqController.dart';
import 'package:mindplex/features/FAQ/model/Content.dart';

import 'package:mindplex/features/FAQ/view/widgets/FaqContent.dart';
import 'package:mindplex/features/FAQ/view/widgets/blog_shimmer.dart';
import 'package:mindplex/routes/app_routes.dart';
import 'package:mindplex/utils/status.dart';

class FaqSearchResult extends StatelessWidget {
  FaqSearchResult({super.key});
  FaqController faqController = Get.find();
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
        height: screenHeight * 0.65,
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Obx(() => faqController.searchStatus == Status.loading
            ? ListView.builder(
                itemCount: 5,
                itemBuilder: (ctx, inx) => const BlogSkeleton(),
              )
            : faqController.searchStatus == Status.error
                ? Center(
                    child: Icon(Icons.error),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                                faqController.searchQuery == ""
                                    ? "search faq..."
                                    : 'Results for: "${faqController.searchQuery.value}"',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w700)),
                          ),
                          IconButton(
                            onPressed: () {
                              faqController.changeSearchMode(false);
                            },
                            icon: Icon(Icons.close),
                            color: Colors.red,
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: screenHeight * 0.50,
                        child: ListView.separated(
                          padding: EdgeInsets.all(10),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 10),
                          itemCount: faqController.faqSearchResult.length + 1,
                          controller: faqController.scrollController,
                          itemBuilder: (context, index) {
                            if (faqController.searchStatus ==
                                    Status.loadingMore &&
                                index == faqController.faqSearchResult.length) {
                              return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 3,
                                itemBuilder: (ctx, inx) => const BlogSkeleton(),
                              );
                            } else if (faqController.searchStatus ==
                                    Status.success &&
                                faqController.faqSearchResult.length == 0) {
                              return Center(
                                child: Text(
                                  "No result found",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 18),
                                ),
                              );
                            } else if (faqController.searchStatus !=
                                    Status.loadingMore &&
                                index == faqController.faqSearchResult.length) {
                              return SizedBox(height: 10);
                            }

                            return Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.white30)),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Get.toNamed(AppRoutes.faqAnswer,
                                      arguments: faqController
                                          .faqSearchResult[index].slug);
                                },
                                child: Text(
                                  faqController.faqSearchResult[index].title,
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 16),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )));
  }
}
