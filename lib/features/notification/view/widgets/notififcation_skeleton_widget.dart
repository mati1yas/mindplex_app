import 'package:flutter/material.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

class NotificationSkeleton extends StatelessWidget {
  const NotificationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ShimmerEffect(
      baseColor: Color.fromARGB(255, 7, 67, 87),
      highlightColor: Color.fromARGB(255, 6, 107, 154),
      way: ShimmerEffectway.ltr,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
        child: Column(
          children: [
            Row(
              children: [
                SkeletonElement(width: 50, height: 50, radius: 25),
                SizedBox(width: 10),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonElement(width: width, height: 12, radius: 25),
                    SizedBox(height: 5),
                    SkeletonElement(width: width * 0.3, height: 12, radius: 25),
                    SizedBox(height: 5),
                    SkeletonElement(width: width * 0.6, height: 12, radius: 25)
                  ],
                ))
              ],
            ),
            Divider(
              thickness: 1,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}

class SkeletonElement extends StatelessWidget {
  const SkeletonElement(
      {super.key,
      required this.width,
      required this.height,
      required this.radius});

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          )),
    );
  }
}
