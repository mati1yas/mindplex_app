import 'package:flutter/material.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

import '../../../../utils/colors.dart';

class BlogSkeleton extends StatelessWidget {
  const BlogSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: blogContainerColor.withAlpha(100),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SkeletonElement(
                    isMarginForAll: true,
                    dimensions: {
                      'height': 40,
                      'width': 40,
                      'margin_all': 10,
                      'radius': 20,
                    },
                    colors: {
                      'base': Color(0xFF103e56),
                      'highlight': Color.fromARGB(255, 28, 105, 146),
                    },
                  ),
                  SkeletonElement(
                    isMarginForAll: false,
                    dimensions: {
                      'width': MediaQuery.of(context).size.width * .4,
                      'height': 18,
                      'margin_left': 8,
                      'margin_right': 3,
                      'radius': 4,
                    },
                    colors: {
                      'base': shimmerEffectBase1,
                      'highlight': shimmerEffectHighlight1,
                    },
                  ),
                  ShimmerEffect(
                    baseColor: const Color.fromARGB(255, 46, 46, 46),
                    highlightColor:
                        const Color.fromARGB(255, 66, 66, 66).withAlpha(200),
                    child: Container(
                      height: 60,
                      width: 20,
                      margin: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      )),
                    ),
                  ),
                  SkeletonElement(
                    isMarginForAll: false,
                    dimensions: {
                      'height': 60,
                      'width': 35,
                      'margin_left': 10,
                    },
                    colors: {
                      'base': Colors.black.withAlpha(200),
                      'highlight': Colors.black.withAlpha(250),
                    },
                  ),
                ],
              ),
              SkeletonElement(
                isMarginForAll: true,
                dimensions: {
                  'width': MediaQuery.of(context).size.width * .8,
                  'height': 30,
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
                  'width': MediaQuery.of(context).size.width * .8,
                  'height': 40,
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
                    width: 5,
                  ),
                  SkeletonElement(
                    isMarginForAll: false,
                    dimensions: {
                      'width': 40,
                      'height': 15,
                      'radius': 4,
                      'margin_bottom': 5
                    },
                    colors: {
                      'base': shimmerEffectBase1,
                      'highlight': shimmerEffectHighlight1,
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SkeletonElement(
                    isMarginForAll: false,
                    dimensions: {
                      'width': 40,
                      'height': 15,
                      'radius': 4,
                      'margin_bottom': 5
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
