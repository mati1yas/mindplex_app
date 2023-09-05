import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex_app/blogs/like_dislike_interaction/like_dislike_controller.dart';
import 'package:mindplex_app/blogs/widgets/blog_content_display.dart';
import 'package:mindplex_app/models/blog_model.dart';

import '../blogs_controller.dart';
import '../comments/comment.dart';

class DetailsPage extends StatelessWidget {
  final Blog details;
  final int index;
  const DetailsPage({super.key, required this.details, required this.index});

  @override
  Widget build(BuildContext context) {
    LikeDislikeConroller likeDislikeConroller = Get.put(LikeDislikeConroller());
    BlogsController blogsController = Get.find();

    return Scaffold(
      backgroundColor: Color(0xFF0c2b46),
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
        backgroundColor: Color.fromARGB(255, 17, 126, 113),
      ),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.82,
            child: SingleChildScrollView(
              child: Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.green,
                              image: DecorationImage(
                                image: NetworkImage(details.authorAvatar ?? ""),
                              ),
                            ),
                          ),
                          Container(
                            child: Container(
                              width: MediaQuery.of(context).size.width * .40,
                              margin: EdgeInsets.only(right: 3, top: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    details.authorDisplayName!,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w200,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    details.authorBio ?? "",
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w200),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                top: 10, left: 30, right: 30, bottom: 10),
                            margin: EdgeInsets.only(top: 15),
                            decoration: const BoxDecoration(
                                color: Color(0xFF0f3e57),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: const Text(
                              'Follow',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w200,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),

                      // Place to Displaye Content
                      Material(
                        color: Color(0xFF0c2b46),
                        child: BlogContentDisplay(
                          data: details.content ?? [],
                        ),
                      )
                    ],
                  )),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            color: Color.fromARGB(255, 17, 126, 113),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  IconButton(
                    onPressed: () {
                      if (details.isUserLiked.value == true) {
                        likeDislikeConroller.removePreviousInteraction(
                            blog: details,
                            index: index,
                            articleSlug: details.slug ?? "",
                            interction: "L");
                      } else if (details.isUserLiked.value == false) {
                        likeDislikeConroller.likeDislikeArticle(
                            blog: details,
                            index: index,
                            articleSlug: details.slug ?? "",
                            interction: "L");
                      }
                    },
                    icon: (details.isUserLiked.value)
                        ? Icon(
                            Icons.thumb_up_off_alt_rounded,
                            color: Color.fromARGB(255, 73, 255, 179),
                          )
                        : Icon(
                            Icons.thumb_up_off_alt_outlined,
                            color: Colors.white,
                          ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  IconButton(
                    onPressed: () {
                      if (details.isUserDisliked.value == true) {
                        likeDislikeConroller.removePreviousInteraction(
                            blog: details,
                            index: index,
                            articleSlug: details.slug ?? "",
                            interction: "L");
                      } else if (details.isUserDisliked.value == false) {
                        likeDislikeConroller.likeDislikeArticle(
                            blog: details,
                            index: index,
                            articleSlug: details.slug ?? "",
                            interction: "D");
                      }

                      ;
                    },
                    icon: details.isUserDisliked.value
                        ? Icon(
                            Icons.thumb_down,
                            color: const Color.fromARGB(255, 230, 96, 86),
                          )
                        : Icon(
                            Icons.thumb_down_off_alt_outlined,
                            color: Colors.white,
                          ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    Icons.share_outlined,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  IconButton(
                    onPressed: () => Get.bottomSheet(
                      MyWidgetComment(post_slug: details.slug!),
                      isScrollControlled: true,
                      ignoreSafeArea: false,
                    ),
                    icon: Icon(
                      Icons.mode_comment_outlined,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    Icons.add_reaction_outlined,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    Icons.check_box_outline_blank,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    Icons.bookmark_add,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
