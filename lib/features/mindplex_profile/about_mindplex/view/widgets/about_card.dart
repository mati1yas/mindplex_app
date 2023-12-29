import 'package:flutter/material.dart';

class AboutCard extends StatelessWidget {
  const AboutCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Material(
          color: Color.fromARGB(255, 3, 70, 93),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    "About Mindplex",
                    style: TextStyle(
                        color: const Color.fromARGB(255, 105, 190, 108),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: Text(
                    "Mindplex is a magazine dedicated to the rapidly-unfolding future, a platform for sharing our community to share and discuss futurist content, and a showcase in using AI tools to improve the media experience. Join us now and help create the future of digital media.",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w100),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 200,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
