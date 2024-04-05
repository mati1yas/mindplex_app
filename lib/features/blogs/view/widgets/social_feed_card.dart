import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';
import 'package:mindplex/features/blogs/view/widgets/interaction_statistics_widget.dart';
import 'package:mindplex/features/blogs/view/widgets/interactions_overlay.dart';
import 'package:mindplex/features/blogs/view/widgets/social_post_time_remaining_widget.dart';
import 'package:mindplex/utils/double_to_string_convertor.dart';

import '../../../../routes/app_routes.dart';
import '../../../authentication/controllers/auth_controller.dart';
import '../../controllers/blogs_controller.dart';

import 'blog_content_display.dart';

class SocialFeedCard extends StatelessWidget {
  SocialFeedCard(
      {super.key, required this.blogsController, required this.index});
  final BlogsController blogsController;
  final int index;

  final AuthController authController = Get.find();
  @override
  Widget build(BuildContext context) {
    Blog blog = blogsController.filteredBlogs[index];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.greenAccent),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                //  will be modified in detail
                //
                if (authController.isGuestUser.value) {
                  authController.guestReminder(context);
                } else {
                  Get.toNamed(AppRoutes.profilePage, parameters: {
                    "me": "notme",
                    "username":
                        blogsController.filteredBlogs[index].authorUsername ??
                            ""
                  });
                }
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    blogsController.filteredBlogs[index].authorAvatar ?? ""),
                radius: 20,
                backgroundColor: Colors.black,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(blog.authorDisplayName ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700)),
                      ),
                      SizedBox(
                        width: 10,
                      ),

                      // added three hours bse of time zone difference . and this widget will be hidden for those that have passed the time limit
                      if (DateTime.now()
                              .difference(blog.publishedTimestamp != null
                                  ? DateTime.parse(blog.publishedTimestamp!)
                                  : DateTime.now())
                              .inHours <
                          (blogsController.socialFeedSetting.value
                                      .timeBeforeDeletion !=
                                  null
                              ? int.parse(blogsController
                                  .socialFeedSetting.value.timeBeforeDeletion!)
                              : 0 + 3))
                        Obx(() => blogsController.loadingReputation.value &&
                                index >= blogsController.startPosition.value
                            ? Container(
                                width: 13,
                                height: 13,
                                child: CircularProgressIndicator(
                                  color: Colors.green[300],
                                ))
                            : GestureDetector(
                                onTap: () {
                                  Get.dialog(PostTimeRemaining(
                                      blog: blogsController
                                          .filteredBlogs[index]));
                                },
                                child: Icon(
                                  Icons.timer_outlined,
                                  color: Colors.white,
                                ),
                              ))
                    ],
                  ),
                  Obx(
                    () => blogsController.loadingReputation.value &&
                            index >= blogsController.startPosition.value
                        ? Container(
                            width: 13,
                            height: 13,
                            child: CircularProgressIndicator(
                              color: Colors.green[300],
                            ))
                        : Text(
                            " MPXR ${(blogsController.filteredBlogs[index].reputation.value != null && blogsController.filteredBlogs[index].reputation.value!.author != null && blogsController.filteredBlogs[index].reputation.value!.author!.mpxr != null) ? numberToString(numberValue: blogsController.filteredBlogs[index].reputation.value!.author!.mpxr!, decimalPlace: 5) : "-"}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        blog.publishedAt ?? "",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300),
                      ),
                      InkWell(
                        onTap: () {
                          _showInteractionsOverlay(context, blog.slug ?? "");
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.tag_faces_outlined,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Interactions",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (DateTime.now()
                          .difference(blog.publishedTimestamp != null
                              ? DateTime.parse(blog.publishedTimestamp!)
                              : DateTime.now())
                          .inHours >=
                      (blogsController
                                  .socialFeedSetting.value.timeBeforeDeletion !=
                              null
                          ? int.parse(blogsController
                              .socialFeedSetting.value.timeBeforeDeletion!)
                          : 0 + 3))
                    Obx(
                      () => blogsController.loadingReputation.value &&
                              index >= blogsController.startPosition.value
                          ? Container(
                              width: 13,
                              height: 13,
                              child: CircularProgressIndicator(
                                color: Colors.green[300],
                              ))
                          : Text(
                              " MPXR ${(blog.reputation.value != null && blog.reputation.value!.postRep != null) ? numberToString(numberValue: blog.reputation.value!.postRep!, decimalPlace: 5) : '  -'}",
                              // " MPXR ${blogsController.filteredBlogs[index].reputation.value != null ? blogsController.filteredBlogs[index].reputation.value!.postRep!.toStringAsFixed(5) : "-"}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  Divider(
                    thickness: 2,
                    color: Colors.white,
                  ),
                  Material(
                    color: Color(0xFF0c2b46),
                    child: BlogContentDisplay(
                      data: blogsController.filteredBlogs[index].content ?? [],
                      padding: 0.0,
                    ),
                  ),
                  InteractionStatistics(
                    blogsController: blogsController,
                    index: index,
                    buttonsInteractive: true,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showInteractionsOverlay(BuildContext context, String slug) {
    showDialog(
      context: context,
      builder: (context) => InteractionsOverlay(slug: slug),
      // isScrollControlled: true,
    );
  }
}
