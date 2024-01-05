import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/blogs/controllers/blogs_controller.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';

import 'package:mindplex/utils/colors.dart';

class InteractionsOverlay extends StatefulWidget {
  final Blog details;
  InteractionsOverlay({required this.details});
  @override
  State<InteractionsOverlay> createState() => _InteractionsOverlayState();
}

class _InteractionsOverlayState extends State<InteractionsOverlay> {
  List<dynamic> interactions = [];
  bool fetched = false;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    BlogsController blogsController = Get.find();
    blogsController
        .getUserInteractions(
          articleSlug: widget.details.slug?.split(' ')[0] as String,
        )
        .then((value) => {
              setState(() {
                this.interactions = value;
                this.fetched = true;
              })
            });
  }

  // final List<dynamic> interactions;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DefaultTabController(
        length: 5, // Number of tabs
        child: FractionallySizedBox(
          widthFactor: 0.9,
          heightFactor: 0.8,
          child: Material(
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: blogContainerColor,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Align at the center
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 15,
                        ),
                        onPressed: () {
                          // Close the overlay
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  Text(
                    'Content Interactions',
                    style: TextStyle(
                        fontSize: 24.0,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 16.0),
                  TabBar(
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                      _buildTab('All', interactions.length),
                      _buildTab('👍', countInteractions('L')),
                      _buildEmojiTab('✨', countInteractions('10024')),
                      _buildEmojiTab('💯', countInteractions('128175')),
                      _buildEmojiTab('😍', countInteractions('128525')),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildInteractionsList(interactions),
                        _buildInteractionsListFiltered('L'),
                        _buildInteractionsListFiltered('10024'),
                        _buildInteractionsListFiltered('128175'),
                        _buildInteractionsListFiltered('128525'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label, int count) {
    return Tab(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1, vertical: 8.0),
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(width: 1.0),
            Text(count.toString(), style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiTab(String emoji, int count) {
    return Tab(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji),
            SizedBox(width: 1.0),
            Text(count.toString(), style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  int countInteractions(String interactionType) {
    return interactions
        .where(
          (interaction) => interaction['interaction_type'] == interactionType,
        )
        .length;
  }

  Widget _buildInteractionsList(List<dynamic> interactions) {
    return fetched
        ? ListView.builder(
            padding: EdgeInsets.only(left: 30),
            itemCount: interactions.length,
            itemBuilder: (context, index) {
              final interaction = interactions[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(interaction['avatar_url'] ?? ''),
                      radius: 20.0,
                    ),
                    // Adjust the spacing as needed
                    // Adjust the spacing as needed
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 26.0,
                      ),
                      child: _buildInteractionIcon(
                          interaction['interaction_type']!, ""),
                    ),
                    SizedBox(width: 8.0), // Adjust the spacing as needed
                    Text(
                      interaction['display_name'] ?? '',
                      style: TextStyle(color: shimmerEffectHighlight1),
                    ),
                  ],
                ),
              );
            },
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  Widget _buildInteractionsListFiltered(String interactionType) {
    final filteredInteractions = interactions
        .where(
          (interaction) => interaction['interaction_type'] == interactionType,
        )
        .toList();

    return _buildInteractionsList(filteredInteractions);
  }

  // String getInteractionSubtitle(String interactionType) {
  Widget _buildInteractionIcon(String interactionType, String? emojiCode) {
    switch (interactionType) {
      case 'L':
        return Icon(Icons.thumb_up, color: Colors.white, size: 16.0);
      case 'D':
        return Icon(Icons.thumb_down, color: Colors.white, size: 16.0);
      case "10024":
        return Text(
          "✨",
          style: TextStyle(fontSize: 16),
        );
      case "128175":
        return Text(
          "💯",
          style: TextStyle(fontSize: 16),
        );
      case "128525":
        return Text(
          "😍",
          style: TextStyle(fontSize: 16),
        );
      default:
        return SizedBox.shrink();
    }
  }
}
