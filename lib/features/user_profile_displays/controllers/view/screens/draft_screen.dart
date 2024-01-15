import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:mindplex/utils/colors.dart";

class DraftScreen extends StatefulWidget {
  const DraftScreen({Key? key}) : super(key: key);

  @override
  _DraftScreenState createState() => _DraftScreenState();
}

class _DraftScreenState extends State<DraftScreen> {
  List _drafts = [];

  Future<void> loadData() async {
    final String response =
        await rootBundle.loadString('assets/bookmarkAPI.json');
    final data = await json.decode(response);
    setState(() {
      _drafts = data['items'];
      print('number of items: ${_drafts.length}');
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: _drafts.length,
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemBuilder: (context, index) {
          var current = _drafts[index];
          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              color: blogContainerColor,
            ),
            height: 280,
            width: 140,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  current['title'] ?? "",
                  style: TextStyle(
                    color: profileGolden,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: Text(
                  current['description'] ?? "",
                  style: TextStyle(color: Colors.white),
                )),
                Row(
                  children: [
                    TextButton(
                      child: Text(
                        'Edit Draft',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {},
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      child: Text(
                        'Delete Draft',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 85, 85),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
