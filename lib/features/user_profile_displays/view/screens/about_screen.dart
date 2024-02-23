import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:mindplex/utils/social_media_Icon_identifier_from_link.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';
import 'package:mindplex/utils/Toster.dart';
import 'package:mindplex/utils/colors.dart';

import '../widgets/user_interest_widget.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({super.key});
  final ProfileController profileController = Get.find();

  String decodeHtmlContent(String content) {
    final decodedContent = parse(content).documentElement!.text;

    return decodedContent;
  }

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: profileGolden),
        color: blogContainerColor,
      ),
      padding: EdgeInsets.all(16),
      child: Obx(
        () => profileController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : ListView(
                shrinkWrap: true,
                children: [
                  TitleText(text: 'Biography'),
                  SizedBox(
                    height: 10,
                  ),
                  Html(
                    data: decodeHtmlContent(
                        profileController.userProfile.value.biography ?? ""),
                    style: {
                      '*': Style(color: Colors.white),
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleText(text: 'Education'),
                            SizedBox(height: 10),

                            Html(
                              data: decodeHtmlContent(profileController
                                              .userProfile.value.education !=
                                          null
                                      ? profileController.userProfile.value
                                          .education!.educationalBackground
                                      : "")
                                  .replaceAll('\\', ''),
                              style: {
                                '*': Style(color: Colors.white),
                              },
                            ),
                            // Text(
                            //   profileController.userProfile.value.education !=
                            //           null
                            //       ? profileController.userProfile.value
                            //           .education!.educationalBackground
                            //       : "",
                            //   style: const TextStyle(color: Colors.white),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleText(text: 'Age'),
                          SizedBox(
                            height: 10,
                          ),
                          profileController.userProfile.value.age != null
                              ? Text(
                                  profileController.userProfile.value.age
                                          .toString() +
                                      ' years',
                                  style: const TextStyle(color: Colors.white),
                                )
                              : Tooltip(
                                  message: "Private data",
                                  child: Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleText(text: 'Sex'),
                          SizedBox(
                            height: 10,
                          ),
                          profileController.userProfile.value.gender != null
                              ? Text(
                                  profileController.userProfile.value.gender
                                      .toString(),
                                  style: const TextStyle(color: Colors.white),
                                )
                              : Tooltip(
                                  message: "Private data",
                                  child: Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TitleText(text: 'Interest'),
                  SizedBox(
                    height: 10,
                  ),
                  UserInterest(profileController: profileController),
                  SizedBox(
                    height: 10,
                  ),
                  TitleText(text: 'Social'),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: profileController
                          .userProfile.value.socialLink!.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return GestureDetector(
                          onTap: () async {
                            if (await canLaunchUrl(Uri.parse(profileController
                                .userProfile.value.socialLink![index]))) {
                              launchUrl(Uri.parse(profileController
                                  .userProfile.value.socialLink![index]));
                            } else {
                              Toster(
                                  message: "Failed To Open the link",
                                  duration: 2);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              children: [
                                // Icon(
                                //   determineSocialLinkIcon(profileController
                                //       .userProfile.value.socialLink![index]),
                                //   color: profileGolden,
                                // ),
                                getSocialLinkIcon(profileController
                                    .userProfile.value.socialLink![index]),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    profileController
                                        .userProfile.value.socialLink![index],
                                    style: TextStyle(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      })
                ],
              ),
      ),
    );
  }
}

class TitleText extends StatelessWidget {
  const TitleText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
          color: profileGolden,
          fontWeight: FontWeight.w700,
        ),
      );
}
