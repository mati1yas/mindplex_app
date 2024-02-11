import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/blogs/controllers/blogs_controller.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';
import 'package:mindplex/features/blogs/view/widgets/blog_content_display.dart';
import 'package:mindplex/features/bottom_navigation_bar/controllers/bottom_page_navigation_controller.dart';
import 'package:mindplex/features/user_profile_displays/controllers/DraftedPostsController.dart';
import 'package:mindplex/routes/app_routes.dart';
import 'package:mindplex/utils/colors.dart';

class DraftCard extends StatelessWidget {
  final Blog blog;

  const DraftCard({
    required this.blog,
    required this.draftedPostsController,
    required this.draftIndex,
  });
  final DraftedPostsController draftedPostsController;
  final int draftIndex;

  @override
  Widget build(BuildContext context) {
    PageNavigationController pageNavigationController = Get.find();

    BlogsController blogsController = Get.find();
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: blogContainerColor,
        border: Border.all(color: profileGolden),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5,
          ),
          BlogContentDisplay(
            data: blog.content ?? [],
            padding: 0,
          ),
          Row(
            children: [
              Obx(() => draftedPostsController
                              .preparingContentForEdition.value ==
                          true &&
                      draftIndex ==
                          draftedPostsController.beingEditedDaftIndex.value
                  ? Container(
                      width: 13,
                      height: 13,
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        draftedPostsController.handleDraftEditing(
                          draftIndex: draftIndex,
                          blogsController: blogsController,
                          draftedBlog: blog,
                          pageNavigationController: pageNavigationController,
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_calendar,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 9,
                          ),
                          Text(
                            'Edit Draft',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )),
              SizedBox(
                width: 5,
              ),
              Container(
                width: 2,
                height: 15,
                color: Colors.grey,
              ),
              SizedBox(
                width: 5,
              ),
              Obx(
                () => draftedPostsController.deletingDraft.value == true &&
                        draftIndex ==
                            draftedPostsController.beingDeletedDaftIndex.value
                    ? Container(
                        width: 13,
                        height: 13,
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          draftedPostsController.deleteDraft(
                              blog: blog, draftIndex: draftIndex);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline_outlined,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 9,
                            ),
                            Text(
                              'Delete Draft',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 85, 85),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
