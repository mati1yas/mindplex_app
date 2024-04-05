import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';

class BlogThumbnailImage extends StatelessWidget {
  const BlogThumbnailImage({
    super.key,
    required this.width,
    required this.blog,
    required this.height,
  });

  final double width;
  final double height;
  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: CachedNetworkImage(
          imageUrl: blog.thumbnailImage ?? "",
          placeholder: (context, url) {
            if (blog.postTypeFormat == "text") {
              return Image.asset(
                  fit: BoxFit.cover, "assets/images/img_not_found_text.png");
            }

            return Image.asset(
                fit: BoxFit.cover, "assets/images/image_not_found_podcast.png");
          },
          errorWidget: (context, url, error) {
            if (blog.thumbnailImage == "default.jpg" &&
                blog.postTypeFormat == "text") {
              return Image.asset(
                  fit: BoxFit.cover, "assets/images/img_not_found_text.png");
            }

            return Image.asset(
                fit: BoxFit.cover, "assets/images/image_not_found_podcast.png");
          },
          fit: BoxFit.cover,
        ),
      ),
      height: height,
      width: width,
    );
  }
}
