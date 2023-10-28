import 'package:flutter/material.dart';

class ModeratorCard extends StatelessWidget {
  final String moderatorImage;
  final String moderatorName;
  final String moderatorRole;
  final String moderatorBio;
  const ModeratorCard(
      {super.key,
      required this.moderatorImage,
      required this.moderatorName,
      required this.moderatorRole,
      required this.moderatorBio});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Material(
          color: Color.fromARGB(255, 3, 70, 93),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Image.asset(
                      fit: BoxFit.cover,
                      height: 100,
                      width: width * 0.25,
                      moderatorImage),
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width * 0.63,
                      child: Text(
                        moderatorName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: width * 0.04),
                      ),
                    ),
                    Container(
                        width: width * 0.63,
                        child: Text(
                          moderatorRole,
                          style: TextStyle(
                              fontWeight: FontWeight.w200,
                              color: Colors.white,
                              fontSize: width * 0.04),
                        )),
                    Container(
                      width: width * 0.63,
                      child: Text(
                        moderatorBio,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: width * 0.04),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
