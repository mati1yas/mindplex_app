import 'package:flutter/material.dart';
import 'package:shimmer_effect/shimmer_effect.dart';
import 'package:mindplex/utils/colors.dart';

class BlogSkeleton extends StatelessWidget {
  const BlogSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 0, right: 0, bottom: 10),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: blogContainerColor.withAlpha(100),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonElement(
                isMarginForAll: false,
                dimensions: {
                  'width': MediaQuery.of(context).size.width * .2,
                  'height': 18,
                  'margin_left': 10,
                  'margin_right': 10,
                  "margin_bottom": 20,
                  "margin_top": 20,
                  'radius': 4,
                },
                colors: {
                  'base': shimmerEffectBase1,
                  'highlight': shimmerEffectHighlight1,
                },
              ),
              SkeletonElement(
                isMarginForAll: true,
                dimensions: {
                  'width': MediaQuery.of(context).size.width,
                  'height': 25,
                  'margin_all': 10,
                  'radius': 8,
                },
                colors: {
                  'base': shimmerEffectBase2,
                  'highlight': shimmerEffectHighlight2,
                },
              ),
              SkeletonElement(
                isMarginForAll: false,
                dimensions: {
                  'width': MediaQuery.of(context).size.width,
                  'height': 50,
                  'margin_left': 10,
                  'margin_right': 10,
                  'radius': 8,
                },
                colors: {
                  'base': shimmerEffectBase2,
                  'highlight': shimmerEffectHighlight2,
                },
              ),
              const Spacer(),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  SkeletonElement(
                    isMarginForAll: false,
                    dimensions: {
                      'width': 40,
                      'height': 15,
                      'radius': 4,
                      'margin_bottom': 20
                    },
                    colors: {
                      'base': shimmerEffectBase1,
                      'highlight': shimmerEffectHighlight1,
                    },
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  SkeletonElement(
                    isMarginForAll: false,
                    dimensions: {
                      'width': 40,
                      'height': 15,
                      'radius': 4,
                      'margin_bottom': 20
                    },
                    colors: {
                      'base': shimmerEffectBase1,
                      'highlight': shimmerEffectHighlight1,
                    },
                  )
                ],
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
