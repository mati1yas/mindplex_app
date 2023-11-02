import 'package:flutter/material.dart';
import 'package:mindplex_app/mindplex_profile/about/widgets/about_card.dart';
import 'package:mindplex_app/mindplex_profile/about/widgets/contact_form.dart';
import 'package:mindplex_app/mindplex_profile/about/widgets/team_member_card.dart';
import 'package:mindplex_app/mindplex_profile/about/widgets/mission_card.dart';
import 'package:mindplex_app/mindplex_profile/about/widgets/values_card.dart';
import 'package:mindplex_app/mindplex_profile/about/widgets/vission_card.dart';

class AboutMindPlex extends StatelessWidget {
  const AboutMindPlex({super.key});

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
                "About",
                style: TextStyle(color: Colors.white, fontSize: 22),
              )),
              height: 70,
            ),
            color: Color.fromARGB(255, 6, 46, 59),
          ),
          SizedBox(
            height: 10,
          ),
          AboutCard(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Text(
                "Our Team",
                style: TextStyle(
                    color: const Color.fromARGB(255, 105, 190, 108),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 3,
              childAspectRatio: 0.6,
              children: [
                TeamMemberCard(),
                TeamMemberCard(),
                TeamMemberCard(),
                TeamMemberCard(),
                TeamMemberCard(),
                TeamMemberCard(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Text(
                "Our Vissions",
                style: TextStyle(
                    color: const Color.fromARGB(255, 105, 190, 108),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          MissionCard(),
          ValuesCard(),
          VissionsCard(),
          ContactForm()
        ],
      ),
    ));
  }
}
