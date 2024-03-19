import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/FAQ/model/Content.dart';

class FaqContent extends StatelessWidget {
  final HtmlContent content;
  FaqContent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (content.type == "li")
          Container(
              padding: EdgeInsets.only(top: 10),
              child: Icon(Icons.circle, size: 10, color: Colors.white70)),
        if (content.type == "li") SizedBox(width: 10),
        Container(
          width: content.type == "li" ? screenWidth * 0.82 : screenWidth * 0.87,
          child: Html(
            data: content.content,
            style: {
              "body": Style(
                color: Colors.white70,
                fontSize: FontSize(16),
                margin: Margins.zero,
                lineHeight: LineHeight.number(1.4),
              )
            },
          ),
        )
      ],
    );
  }
}
