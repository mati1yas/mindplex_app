import 'package:flutter/material.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';
import 'package:mindplex/features/user_profile_displays/models/follower_model.dart';
import 'package:mindplex/features/user_profile_displays/view/widgets/followers_overlay.dart';
import 'package:mindplex/utils/colors.dart';
import 'package:mindplex/utils/profile_page_button_widget.dart';

class FollowerOrFollowingUserTile extends StatelessWidget {
  const FollowerOrFollowingUserTile({
    super.key,
    required this.follower,
    required this.profileController,
  });

  final FollowerModel follower;
  final ProfileController profileController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(follower.avatarUrl ?? ""),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            follower.displayName ?? "",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(color: shimmerEffectHighlight1),
          ),
        ),
        // Spacer(),
        Container(
          child: Row(
            children: [
              ProfilePageOutlinedButton(
                buttonAction: () {
                  profileController.sendFollowRequest(
                      userName: follower.username ?? "");
                },
                buttonColor: profileController.isSendingFollowRequest.value
                    ? Color.fromARGB(255, 229, 146, 171)
                    : Color.fromARGB(255, 225, 62, 111),
                buttonName:
                    follower.isFollowing ?? false ? "Unfollow " : "Follow",
                buttonWidthFactor: 0.25,
                buttonHeight: 25,
                buttonRadius: 10,
              )
            ],
          ),
        ),
      ],
    );
  }
}
