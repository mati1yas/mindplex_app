import 'package:flutter/material.dart';
import 'package:mindplex/utils/colors.dart';

class FollowersOverlay extends StatelessWidget {
  final List<dynamic> followers;

  const FollowersOverlay({Key? key, required this.followers});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.9,
        heightFactor: 0.8,
        child: Material(
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: blogContainerColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 15,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                Text(
                  'Followers',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.0),
                // List of followers
                Expanded(
                  child: ListView.builder(
                    itemCount: followers.length,
                    itemBuilder: (context, index) {
                      final follower = followers[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(follower['avatar_url']),
                        ),
                        title: Text(
                          follower['display_name'],
                          style: TextStyle(color: shimmerEffectHighlight1),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
