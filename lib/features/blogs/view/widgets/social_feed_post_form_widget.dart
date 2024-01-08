import 'package:flutter/material.dart';

class SocialFeedForm extends StatelessWidget {
  const SocialFeedForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 4, 28, 49),
                border: OutlineInputBorder()),
            maxLines: 2,
            minLines: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.headphones_outlined,
                    color: Colors.green,
                  ),
                  Icon(
                    Icons.video_camera_back_outlined,
                    color: Colors.red[200],
                  ),
                  Icon(
                    Icons.image,
                    color: Color.fromARGB(255, 5, 175, 223),
                  )
                ],
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 5, 209, 224))),
                  onPressed: () {},
                  child: Text("Post"))
            ],
          )
        ],
      ),
    );
  }
}
