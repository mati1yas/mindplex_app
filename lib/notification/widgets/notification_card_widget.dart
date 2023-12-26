import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mindplex/blogs/blogs_controller.dart';

import '../../models/notification_model.dart';
import '../../routes/app_routes.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key, required this.notification});

  final NotificationModel notification;

  String buildReactionType(String type) {
    final reactionTypePhrase = {
      "friendship_req": "has sent you a friend request",
      "content_like": "liked your post",
      "follow": "started following you",
      "post_comment": "commented on your post",
      "content_react": "reacted to your post",
      "content_share": "shared your post",
      "moderator_approved": "Your post has been approved by a moderator"
    };
    return reactionTypePhrase[type] ?? type;
  }

  String formatNotificationTime(String reactionTime) {
    DateTime dateTime = DateTime.parse(reactionTime);
    String formattedDate = DateFormat.yMMMMd().format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.profilePage, parameters: {
                      "me": "notme",
                      "username": notification.username ?? ""
                    });
                  },
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(notification.avatar ??
                        "https://secure.gravatar.com/avatar/44cb6ed8fa0451a09a6387dc8bf2533a?s=260&d=mm&r=g"),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              '${notification.firstName! + " " + notification.lastName! + " " + buildReactionType(notification.type!)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        ],
                      ),
                      Text(
                        formatNotificationTime(
                            notification.interactedAt ?? "   "),
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Divider(
            height: 10,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
