import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mindplex_app/mindplex_profile/moderators/widgets/moderator_applicationform_widget.dart';
import 'package:mindplex_app/mindplex_profile/moderators/widgets/moderator_card.dart';

class ModeratorsPage extends StatelessWidget {
  const ModeratorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 6, 46, 59),
        body: ListView(
          children: [
            Material(
              elevation: 10,
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Center(
                    child: Text(
                  "Our Moderators",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                )),
                height: 70,
              ),
              color: Color.fromARGB(255, 6, 46, 59),
            ),
            SizedBox(
              height: 10,
            ),
            ModeratorCard(
              moderatorImage: 'assets/images/person1.jpg',
              moderatorName: "Matiyas Seifu",
              moderatorRole: "Mobile Developer",
              moderatorBio:
                  "I am 5th year software Engineering student I am really passionate about Machine learning and AI .",
            ),
            ModeratorCard(
              moderatorImage: 'assets/images/cover_image.PNG',
              moderatorName: "Matiyas Seifu",
              moderatorRole: "ML Engineer",
              moderatorBio:
                  "I am 5th year software Engineering student I am really passionate about Machine learning and AI .",
            ),
            ModeratorCard(
              moderatorImage: 'assets/images/profile.PNG',
              moderatorName: "Matiyas Seifu",
              moderatorRole: "Mobile Developer",
              moderatorBio:
                  "I am 5th year software Engineering student I am really passionate about Machine learning and AI .",
            ),
            ModeratorApplicationForm()
          ],
        ),
      ),
    );
  }
}
