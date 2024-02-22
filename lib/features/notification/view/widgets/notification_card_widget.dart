import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mindplex/features/blogs/controllers/blogs_controller.dart';
import 'package:mindplex/utils/colors.dart';
import 'package:mindplex/utils/constatns.dart';

import '../../models/notification_model.dart';
import '../../../../routes/app_routes.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key, required this.notification});

  final NotificationModel notification;

  String buildReactionType(
    String type,
    String message,
  ) {
    final reactionTypePhrase = {
      "friendship_req": "has sent you a friend request",
      "content_like": "liked your podcast",
      "follow": "started following you",
      "post_comment": "commented on your podcast",
      "content_react": "reacted to your podcast",
      "content_share": message,
      "moderator_approved":
          "Your requested content has been approved by a moderator",
      "publish": "published a new $message",
      "claim_start": "claimed your Request"
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
                          Expanded(
                            child: Text(
                              '${notification.firstName! + " " + notification.lastName! + " " + buildReactionType(notification.type ?? " ", notification.message ?? " ")}',
                              style: TextStyle(
                                color: bodyTextColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
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
