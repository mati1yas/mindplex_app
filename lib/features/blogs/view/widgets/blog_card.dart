import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/authentication/controllers/auth_controller.dart';
import 'package:mindplex/features/blogs/models/reputation_model.dart';
import 'package:mindplex/features/blogs/view/widgets/interaction_statistics_widget.dart';
import 'package:mindplex/utils/colors.dart';
import 'package:mindplex/utils/double_to_string_convertor.dart';

import '../../controllers/blogs_controller.dart';
import '../../../../routes/app_routes.dart';
import '../screens/blog_detail_page.dart';

class BlogCard extends StatelessWidget {
  BlogCard({
    super.key,
    required this.blogsController,
    required this.index,
  });

  final BlogsController blogsController;
  final int index;

  AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: Container(
        child: Column(
          children: [
            Row(
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
                        "username": blogsController
                                .filteredBlogs[index].authorUsername ??
                            ""
                      });
                    }
                  },
                  child: CircleAvatar(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: CachedNetworkImage(
                        imageUrl:
                            blogsController.filteredBlogs[index].authorAvatar ??
                                "",
                        placeholder: (context, url) =>
                            Image.asset('assets/images/user_avatar.png'),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/images/user_avatar.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    radius: 20,
                    backgroundColor: Colors.white,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(DetailsPage(
                          index: index,
                          details: blogsController.filteredBlogs[index]));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    blogsController.filteredBlogs[index]
                                            .authorDisplayName ??
                                        "",
                                    style: TextStyle(
                                      color: titleTextColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Obx(
                                    () => blogsController
                                                .loadingReputation.value &&
                                            index >=
                                                blogsController
                                                    .startPosition.value
                                        ? Container(
                                            width: 13,
                                            height: 13,
                                            child: CircularProgressIndicator(
                                              color: Colors.green[300],
                                            ),
                                          )
                                        : Text(
                                            " MPXR ${blogsController.filteredBlogs[index].reputation.value != null ? numberToString(numberValue: blogsController.filteredBlogs[index].reputation.value!.author!.mpxr!, decimalPlace: 2) : "-"}",
                                            style: TextStyle(
                                                color: titleTextColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.more_horiz,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                              Text(
                                blogsController
                                        .filteredBlogs[index].publishedAt ??
                                    "",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 123, 122, 122),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                  style: TextStyle(
                                      color: titleTextColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  blogsController
                                          .filteredBlogs[index].postTitle ??
                                      ""),
                            ],
                          ),
                        ),
                        Html(
                            style: {
                              "*": Style(color: Colors.white),
                            },
                            data:
                                blogsController.filteredBlogs[index].overview ??
                                    ""),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                blogsController
                                        .filteredBlogs[index].minToRead ??
                                    "",
                                style: TextStyle(
                                    color: bodyTextColor,
                                    fontWeight: FontWeight.w300),
                              ),
                              Obx(
                                () => blogsController.loadingReputation.value &&
                                        index >=
                                            blogsController.startPosition.value
                                    ? Container(
                                        width: 13,
                                        height: 13,
                                        child: CircularProgressIndicator(
                                          color: Colors.green[300],
                                        ))
                                    : Text(
                                        " MPXR ${blogsController.filteredBlogs[index].reputation.value != null ? numberToString(numberValue: blogsController.filteredBlogs[index].reputation.value!.postRep!, decimalPlace: 5) : "-"}",
                                        style: TextStyle(
                                            color: titleTextColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  // blog thumbnail image
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      child: CachedNetworkImage(
                                        imageUrl: blogsController
                                                .filteredBlogs[index]
                                                .thumbnailImage ??
                                            "",
                                        placeholder: (context, url) {
                                          if (blogsController
                                                  .filteredBlogs[index]
                                                  .postTypeFormat ==
                                              "text") {
                                            return Image.asset(
                                                fit: BoxFit.cover,
                                                "assets/images/img_not_found_text.png");
                                          }

                                          return Image.asset(
                                              fit: BoxFit.cover,
                                              "assets/images/image_not_found_podcast.png");
                                        },
                                        errorWidget: (context, url, error) {
                                          if (blogsController
                                                      .filteredBlogs[index]
                                                      .thumbnailImage ==
                                                  "default.jpg" &&
                                              blogsController
                                                      .filteredBlogs[index]
                                                      .postTypeFormat ==
                                                  "text") {
                                            return Image.asset(
                                                fit: BoxFit.cover,
                                                "assets/images/img_not_found_text.png");
                                          }

                                          return Image.asset(
                                              fit: BoxFit.cover,
                                              "assets/images/image_not_found_podcast.png");
                                        },
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    height: 170,
                                    width: width * 0.8,
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 1, right: 8.0),
                                      child: Container(
                                          height: 60,
                                          width: 35,
                                          margin:
                                              EdgeInsets.only(left: 10, top: 0),
                                          decoration: const BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(5),
                                                bottomRight: Radius.circular(5),
                                              )),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: blogsController
                                                            .filteredBlogs[
                                                                index]
                                                            .postTypeFormat ==
                                                        "text"
                                                    ? const Icon(
                                                        Icons
                                                            .description_outlined,
                                                        color:
                                                            Color(0xFF8aa7da),
                                                        size: 20,
                                                      )
                                                    : blogsController
                                                                .filteredBlogs[
                                                                    index]
                                                                .postTypeFormat ==
                                                            "video"
                                                        ? const Icon(
                                                            Icons.videocam,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    185,
                                                                    127,
                                                                    127),
                                                            size: 20,
                                                          )
                                                        : const Icon(
                                                            Icons.headphones,
                                                            color: Colors.green,
                                                            size: 20,
                                                          ),
                                              )
                                            ],
                                          )),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              InteractionStatistics(
                                blog: blogsController.filteredBlogs[index],
                                blogsController: blogsController,
                                index: index,
                                buttonsInteractive: false,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),

            SizedBox(
              height: 20,
            )
            // Divider(
            //   color: Colors.white,
            //   thickness: 1,
            // )
          ],
        ),
      ),
    );
  }
}
