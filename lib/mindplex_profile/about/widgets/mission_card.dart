import 'package:flutter/material.dart';

class MissionCard extends StatelessWidget {
  const MissionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color.fromARGB(70, 199, 33, 249),
                Color.fromARGB(70, 199, 33, 249),
                Color.fromARGB(255, 3, 70, 93)
              ])),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Missions",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Image.asset(width: 100, 'assets/images/missions.png')
                  ],
                ),
              ),
              Container(
                width: 220,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Mindplex plans to build a great futurist magazine. We will bring you cutting edge ideas from the biggest names in artificial intelligence, biotech, blockchain, robotics, and other fields, and cover technology breakthroughs as they happen. We will build a community around our shared interests, and manage that community wisely, using our blockchain-based reputation system to promote the best content and most trustworthy speech.",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w100),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
