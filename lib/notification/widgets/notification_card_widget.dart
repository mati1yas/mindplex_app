import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key, required this.notification});

  final NotificationModel notification;

  String buildReactionType(String type) {
    final reactionTypePhrase = {
      "friendship_req": "has sent you a friend request ",
      "content_react": "reacted to your post",
      "content_like": "liked your post",
      "content_dislike": "disliked your post "
    };
    return reactionTypePhrase[type] ?? "";
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
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(notification.avatar ?? ""),
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
