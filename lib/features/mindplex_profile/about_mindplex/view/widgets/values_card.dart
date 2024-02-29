import 'package:flutter/material.dart';

class ValuesCard extends StatelessWidget {
  const ValuesCard({super.key});

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
                Color.fromARGB(255, 3, 70, 93),
                Color.fromARGB(8, 199, 33, 249),
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
                      "Values",
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "We believe in freedom of conscience. We want you to be free to investigate for yourself what is true, and to discuss it. While we were founded by techno-optimists interested in the Technological Singularity, we welcome other viewpoints. We will try to minimize the amount of control centralized power has over discourse, as this is known to distort free and open discussion. We are concerned about the inaccuracy and low quality that characterizes much of our digital media today. Some of our founding team lived through the Tigrayan war, seeing the violence fueled partly by online hate-speech. We value high-quality, trustworthy media, not harmful and deceptive speech.",
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
