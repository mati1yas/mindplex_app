import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mindplex/mindplex_profile/moderators/widgets/moderator_applicationform_widget.dart';
import 'package:mindplex/mindplex_profile/moderators/widgets/moderator_card.dart';

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
              moderatorImage: 'assets/images/default_user.jpeg',
              moderatorName: "Henderson Robert",
              moderatorRole: "Moderator",
              moderatorBio:"My name is Henderson Robert, I’ve been an online content moderator for mindplex..."),
            ModeratorApplicationForm()
          ],
        ),
      ),
    );
  }
}
