import 'package:flutter/material.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';
import 'package:mindplex/utils/colors.dart';

class FollowersOverlay extends StatefulWidget {
  final ProfileController profileController;

  const FollowersOverlay({Key? key, required this.profileController});

  @override
  State<FollowersOverlay> createState() => _FollowersOverlayState();
}

class _FollowersOverlayState extends State<FollowersOverlay> {
  List<dynamic> followers = [];
  bool fetched = false;
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    print(widget.profileController.userProfile.value.username);
    _fetchFollowers();

    // Add a listener to the scroll controller to check when the user reaches the end of the list
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !widget.profileController.reachedEndofFollowers.value) {
        _fetchFollowers();
      }
    });
  }

  // Fetch followers method
  void _fetchFollowers() {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      widget.profileController
          .fetchFollowers(
              username: widget.profileController.userProfile.value.username!)
          .then((value) => {
                setState(() {
                  this.followers = widget.profileController.followers;
                  this.fetched = true;
                  isLoading = false;
                })
              });
    }
  }

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
                this.fetched
                    ? Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: this.followers.length +
                              (widget.profileController.reachedEndofFollowers
                                      .value
                                  ? 0
                                  : 1), // +1 for the loading spinner if not reached end
                          itemBuilder: (context, index) {
                            if (index < this.followers.length) {
                              final follower = this.followers[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(follower['avatar_url']),
                                ),
                                title: Text(
                                  follower['display_name'],
                                  style:
                                      TextStyle(color: shimmerEffectHighlight1),
                                ),
                              );
                            } else if (!widget.profileController
                                .reachedEndofFollowers.value) {
                              // Loading spinner at the bottom
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            } else {
                              return Container(); // Return an empty container if reached end
                            }
                          },
                        ),
                      )
                    : Center(child: CircularProgressIndicator())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
