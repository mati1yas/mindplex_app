import 'package:flutter/material.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF0c2b46),
      child: Center(
        child: Text("groups Page"),
      ),
    );
  }
}
