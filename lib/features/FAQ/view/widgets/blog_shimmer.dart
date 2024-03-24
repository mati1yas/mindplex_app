import 'package:flutter/material.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

import '../../../../utils/colors.dart';

class BlogSkeleton extends StatelessWidget {
  const BlogSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 0, right: 0, bottom: 10),
      height: 40,
      decoration: BoxDecoration(
          // borderRadius: BorderRadius.all(Radius.circular(10)),
          // color: blogContainerColor.withAlpha(100),
          ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SkeletonElement(
                isMarginForAll: false,
                dimensions: {
                  'width': MediaQuery.of(context).size.width * .9,
                  'height': 30,
                  'margin_left': 10,
                  'margin_right': 10,
                  "margin_bottom": 5,
                  "margin_top": 5,
                  'radius': 4,
                },
                colors: {
                  'base': shimmerEffectBase1,
                  'highlight': shimmerEffectHighlight1,
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SkeletonElement extends StatelessWidget {
  const SkeletonElement({
    super.key,
    required this.isMarginForAll,
    required this.dimensions,
    required this.colors,
  });

  final bool isMarginForAll;
  final Map<String, double> dimensions;
  final Map<String, Color> colors;

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      baseColor: Color(0xFF6eded0).withOpacity(.3),
      highlightColor: Color(0xFF6eded0),
      child: Container(
        margin: isMarginForAll
            ? EdgeInsets.all(dimensions['margin_all']!)
            : EdgeInsets.fromLTRB(
                dimensions['margin_left'] ?? 0,
                dimensions['margin_top'] ?? 0,
                dimensions['margin_right'] ?? 0,
                dimensions['margin_bottom'] ?? 0,
              ),
        width: dimensions['width'],
        height: dimensions['height'],
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(dimensions['radius'] ?? 0),
          color: Color(0xFF6eded0).withOpacity(.3),
        ),
      ),
    );
  }
}
