import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserAvatarWidget extends StatelessWidget {
  const UserAvatarWidget({
    super.key,
    required this.imageUrl,
    required this.radius,
  });

  final String imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) =>
              Image.asset('assets/images/user_avatar.png'),
          errorWidget: (context, url, error) =>
              Image.asset('assets/images/user_avatar.png'),
          fit: BoxFit.cover,
        ),
      ),
      radius: radius,
      backgroundColor: Colors.white,
    );
  }
}
