import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mindplex_app/models/blog_model.dart';
import 'package:mindplex_app/models/popularModel.dart';

class DetailsPage extends StatelessWidget {
  final Blog details;
  const DetailsPage({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0c2b46),
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.only(top: 100),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green,
                        image: DecorationImage(
                          image: NetworkImage(details.authorAvatar ?? ""),
                        ),
                      ),
                    ),
                    Container(
                      child: Container(
                        width: MediaQuery.of(context).size.width * .40,
                        margin: EdgeInsets.only(right: 3, top: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              details.authorDisplayName!,
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "It's easier to fool people than to confince them that they've been fooled. I spent the last three years as a design Ethicist It's easier to fool people than to confince them that they've been fooled",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          top: 10, left: 30, right: 30, bottom: 10),
                      margin: EdgeInsets.only(top: 15),
                      decoration: const BoxDecoration(
                          color: Color(0xFF0f3e57),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: const Text(
                        'Follow',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w200,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Html(
                    data: details.content,
                    style: {
                      'p': Style(
                          padding: HtmlPaddings.all(10),
                          fontWeight: FontWeight.w300,
                          fontSize: FontSize(17),
                          color: Colors.white),
                      'p.has-text-align-center': Style(
                          alignment: Alignment.centerRight,
                          padding: HtmlPaddings.only(left: 40, right: 40),
                          fontWeight: FontWeight.w300,
                          fontSize: FontSize(17),
                          color: Colors.white),
                      'figcaption': Style(
                          padding: HtmlPaddings.all(10),
                          alignment: Alignment.topRight,
                          fontWeight: FontWeight.w300,
                          fontSize: FontSize(15),
                          color: Colors.yellow),
                      'h2': Style(
                          padding: HtmlPaddings.all(10),
                          fontWeight: FontWeight.bold,
                          fontSize: FontSize(22),
                          color: Colors.white),
                      'h1': Style(
                          fontWeight: FontWeight.bold,
                          fontSize: FontSize(22),
                          color: Colors.red),
                      'h3': Style(
                          fontWeight: FontWeight.bold,
                          fontSize: FontSize(22),
                          color: Colors.white)
                    },
                  ),
                )
              ],
            )),
      ),
    );
  }
}
