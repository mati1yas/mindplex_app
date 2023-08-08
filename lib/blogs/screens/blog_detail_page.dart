import 'package:flutter/material.dart';
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
      body: Container(
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
              SizedBox(
                height: 10,
              ),
              Stack(
                children: [
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      image: const DecorationImage(
                          image: AssetImage("assets/images/cover_image.PNG"),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    left: 30,
                    bottom: 15,
                    child: details.postTypeFormat == "read"
                        ? const Icon(
                            Icons.description_outlined,
                            color: Color(0xFF8aa7da),
                            size: 30,
                          )
                        : details.postTypeFormat == "watch"
                            ? const Icon(
                                Icons.videocam,
                                color: Color.fromARGB(255, 185, 127, 127),
                                size: 30,
                              )
                            : const Icon(
                                Icons.headphones,
                                color: Colors.green,
                                size: 30,
                              ),
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  "How Technology is Hijacking your Mind",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 24, 200, 179)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 350,
                child: Text(
                  "If you’re here, you probably know about my situation. I’m going to assume that you already know that for the last almost eight months I’ve been fighting a very public battle that involves topics I didn’t know much about until recently boundaries, consent. For eight long gruelss relationships, to save my own mental health." +
                      "                                                                                 " +
                      "From February through April 2021, we filmed for the show. They filmed us both in our hometown. They filmed scenes with our family and friends at my house and at his. They even filmed us in Hawaii!",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      color: Colors.white),
                ),
              )
            ],
          )),
    );
  }
}
