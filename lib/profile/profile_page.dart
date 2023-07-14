import 'package:flutter/material.dart';

import 'about_screen.dart';
import 'bookmark_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() {
    return _ProfilePage();
  }
}

class _ProfilePage extends State<ProfilePage> {
  //array og pages
  final double coverHeight = 280;
  var screens = [
    {'name': 'About', 'active': true, 'widget': const AboutScreen()},
    {
      'name': 'Published Content',
      "active": false,
      'widget': const BookmarkScreen()
    },
    {'name': 'Bookmarks', "active": false, 'widget': const BookmarkScreen()},
    {'name': 'Drafts', "active": false, 'widget': const BookmarkScreen()}
  ];

  Widget activeScreen = const AboutScreen();
  //make this an object with 3 values
  //1 of widget
  //2 activeStatus of boolean
  //3 identifier of int

  void switchScreen(int num) {
    setState(() {
      switch (num) {
        case 1:
          activeScreen = const AboutScreen();
          break;
        case 2:
          activeScreen = const BookmarkScreen();
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            const Color.fromARGB(255, 12, 45, 68), // can and should be removed
        body: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            buildTop(),
            // buildContent(),
            buildUserName(),
            buildStatus(),
            buidScreens()
          ],
        ));
  }

  Widget buildCoverImage() {
    // decoration:BoxDecoration()), add curves to the image
    return Image.network(
        'https://images.unsplash.com/photo-1509745651274-ddeb337c854a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fDE0NDAlMjB4JTIwMTIwMHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=600&q=60',
        width: double.infinity,
        height: coverHeight,
        fit: BoxFit.cover);
  }

  Widget buildTop() {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          buildCoverImage(),
          Positioned(
            // top:,
            top: 260,
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 55, 153, 159),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(106, 37),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: null,
                child: const Text(
                  'Change Info',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                )),
          )
          // Column(mainAxisSize: MainAxisSize.min, children: [
          //   const Text("Profile page"),
          //   // rgb(16, 63, 87)
          //   Container(
          //     margin: const EdgeInsets.all(40),
          //     child: Row(
          //       children: [
          //         OutlinedButton(
          //           style: OutlinedButton.styleFrom(
          //             backgroundColor: const Color.fromARGB(255, 16, 63, 87),
          //             foregroundColor: Colors.white,
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(40),
          //             ),
          //           ),
          //           onPressed: () {
          //             switchScreen(1);
          //           },
          //           child: const Text('About'),
          //         ),
          //         OutlinedButton(
          //           style: OutlinedButton.styleFrom(
          //             backgroundColor:
          //                 const Color.fromARGB(255, 137, 69, 118),
          //             foregroundColor: Colors.white,
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(40),
          //             ),
          //           ),
          //           onPressed: () {
          //             switchScreen(2);
          //           },
          //           child: const Text('Bookmarks'),
          //         ),
          //       ],
          //     ),
          //   ),
          //   // switchScreen(),
          //   activeScreen,
          //   // AboutScreen(),
          //   // BookmarkScreen(),
          // ]
          // )
        ],
      ),
    );
  }

  Widget buildUserName() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 5),
                child: const Text(
                  'Ayden Tiao',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Text(
                '@AydenTiao',
                style: TextStyle(
                  color: Color.fromARGB(255, 190, 190, 190),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              // OutlinedButton(onPressed: onPressed, child: child)
            ],
          ),
          OutlinedButton(
            onPressed: null,
            style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                minimumSize: Size(117, 37),
                backgroundColor: const Color.fromARGB(255, 225, 62, 111),
                foregroundColor: Colors.white),
            child: const Text(
              'Connect Wallet',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatus() {
    var status = [
      {"amount": "20", "value": "Friends"},
      {"amount": "120", "value": "Following"},
      {"amount": "100", "value": "Followers"},
      {"amount": "100", "value": " MPXR"}
    ];
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        ...status.map(
          (item) {
            return Row(
              children: [
                Column(
                  children: const [
                    Text(
                      '22',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Following',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 190, 190, 190),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 24.0,
                  width: 1.0,
                  color: const Color.fromARGB(255, 73, 150, 154),
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                ), //straight line after each value
              ],
            );
          },
        )
        // Text(
        //   '20',
        //   style: TextStyle(
        //     color: Colors.white,
        //     fontSize: 16,
        //     fontWeight: FontWeight.w700,
        //   ),
        // ),
        // Text(
        //   'Friends',
        //   style: TextStyle(
        //     color: Colors.white,
        //     fontSize: 26,
        //     fontWeight: FontWeight.w700,
        //   ),
        // ),
        // SizedBox(width: 46, height: 1),
        ,
      ]),
    );
  }

  Widget buidScreens() {
    return Column(children: [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...screens.map((item) {
              return Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 137, 69, 118),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'About',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            })
          ],
        ),
      ),
    ]);
  }
}
