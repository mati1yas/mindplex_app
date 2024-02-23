import 'package:flutter/material.dart';
import 'package:mindplex/features/notification/view/widgets/notififcation_skeleton_widget.dart';

class NotificationLoaderInidcator extends StatelessWidget {
  const NotificationLoaderInidcator({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (context, index) {
          return NotificationSkeleton();
        });
  }
}
