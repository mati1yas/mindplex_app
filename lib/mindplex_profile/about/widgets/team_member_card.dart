import 'package:flutter/material.dart';
import 'package:mindplex/models/TeamMember.dart';

class TeamMemberCard extends StatelessWidget {
  final TeamMember teamMember;
  const TeamMemberCard({super.key,required this.teamMember});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Color.fromARGB(255, 3, 70, 93),
          height: 500,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(teamMember.profilePic!),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  teamMember.name!,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Container(
                  child: Text(
                    teamMember.position!,
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontSize: width * 0.04, color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: height * 0.067,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        // border: Border.all(
                        //   width: 2,
                        //   color: const Color.fromARGB(208, 178, 178, 178),
                        // ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                            fit: BoxFit.cover,
                            "assets/images/linkedin_white_logo.png"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
