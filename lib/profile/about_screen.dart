import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindplex_app/utils/colors.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});
  @override
  State<AboutScreen> createState() {
    return _AboutScreen();
  }
}

class TitleText extends StatelessWidget {
  const TitleText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
          color: Color.fromARGB(255, 255, 226, 121),
          fontWeight: FontWeight.w700,
        ),
      );
}

class _AboutScreen extends State<AboutScreen> {
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: blogContainerColor,
        ),
        height: 380,
        width: 140,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 323,
              height: 127,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleText(text: 'Biography'),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Text(
                      'If you\’re here, you probably know about my situation. I\’m going to assume that you already know that for the last almost eight months I\’ve been fighting a very public battle that involves topics I didn\’t know much about until recently boundaries, consent.',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleText(text: 'Education'),
                    SizedBox(height: 10),
                    Text(
                      'PhD in design',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleText(text: 'Age'),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '31 years',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleText(text: 'Sex'),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Male',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
