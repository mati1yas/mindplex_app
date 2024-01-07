import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/blogs/controllers/blogs_controller.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';

import 'package:mindplex/utils/colors.dart';
import 'package:mindplex/utils/constatns.dart';

class InteractionsOverlay extends StatefulWidget {
  final List<dynamic> interactions;
  final String slug;
  InteractionsOverlay({required this.interactions, required this.slug});

  @override
  State<InteractionsOverlay> createState() => _InteractionsOverlayState();
}

class _InteractionsOverlayState extends State<InteractionsOverlay>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  bool fetched = false;
  Map<String, List<dynamic>> interactionsMap = {};
  List<dynamic> interactions = [];
  List<Map<String, dynamic>> uniqueInteractions = [];

  @override
  void initState() {
    super.initState();

    for (var interactionType in _getAllInteractionTypes()) {
      interactionsMap[interactionType] = [];
    }

    this.interactions = widget.interactions;

    BlogsController blogsController = Get.find();
    blogsController
        .getUserInteractions(
          articleSlug: widget.slug.split(' ')[0],
        )
        .then((value) => {
              value.sort((a, b) {
                int indexOfA =
                    _getAllInteractionTypes().indexOf(a['interaction_type']);
                int indexOfB =
                    _getAllInteractionTypes().indexOf(b['interaction_type']);
                return indexOfA.compareTo(indexOfB);
              }),
              setState(() {
                this.interactions = value;
                this.fetched = true;
                for (var interactionType in _getAllInteractionTypes()) {
                  if (this.interactions.any((interaction) =>
                      interaction['interaction_type'] == interactionType)) {
                    interactionsMap[interactionType] = this
                        .interactions
                        .where((interaction) =>
                            interaction['interaction_type'] == interactionType)
                        .toList();
                  } else {
                    interactionsMap[interactionType] = [];
                  }
                  print('initial...');
                  print(interactionsMap);
                }
              })
            });
  }

  List<String> _getAllInteractionTypes() {
    return [
      'all',
      'L',
      'D',
      "128175",
      "128152",
      "128525",
      "10024",
      "127881",
      "128079",
      "129000",
      "128564",
      "128545",
      "10060",
      "129326",
      "128169"
    ];
  }

  int _getTabCount() {
    List<String> interactionTypes = [
      'all',
      'L',
      'D',
      "128175",
      "128152",
      "128525",
      "10024",
      "127881",
      "128079",
      "129000",
      "128564",
      "128545",
      "10060",
      "129326",
      "128169",
    ];
    return interactionTypes
            .where((type) => countInteractions(type) > 0)
            .length +
        1;
  }

  void _handleTabChange(int index) async {
    setState(() {
      this.fetched = false;
    });

    BlogsController bc = Get.find();

    final userInteraction = await bc.getUserInteraction(
      articleSlug: widget.slug,
      interactionType: getInteractionTypeByTabIndex(index),
    );

    setState(() {
      this.interactionsMap["${getInteractionTypeByTabIndex(index)}"] =
          userInteraction;
      this.fetched = true;
    });

    // Call your functionality here when the tab changes
    // Your existing onTap functionality should be placed here
  }

  String getInteractionTypeByTabIndex(int index) {
    if (index == 0) {
      return 'all';
    }
    for (var interaction in this.interactions) {
      if (!uniqueInteractions.any((unique) =>
          unique['interaction_type'] == interaction['interaction_type'])) {
        uniqueInteractions.add(interaction);
      }
    }

    if (index < uniqueInteractions.length + 1) {
      if (uniqueInteractions[index - 1]['interaction_type'] == "L") {
        return 'like';
      }
      if (uniqueInteractions[index - 1]['interaction_type'] == "D") {
        return 'dislike';
      }
      return uniqueInteractions[index - 1]['interaction_type'] ?? 'all';
    } else {
      return 'all';
    }
  }

  int countInteractions(String interactionType) {
    return this
        .interactions
        .where(
          (interaction) => interaction['interaction_type'] == interactionType,
        )
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DefaultTabController(
        length: _getTabCount(),
        child: Builder(builder: (context) {
          return FractionallySizedBox(
            widthFactor: 0.9,
            heightFactor: 0.8,
            child: Material(
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: blogContainerColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TabBar(
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.label,
                      onTap: _handleTabChange,
                      tabs: [
                        _buildTab('All', this.interactions.length),
                        if (countInteractions('L') > 0)
                          _buildTab('👍', countInteractions('L')),
                        if (countInteractions('D') > 0)
                          _buildTab('👎', countInteractions('D')),
                        if (countInteractions('128175') > 0)
                          _buildEmojiTab('💯', countInteractions('128175')),
                        if (countInteractions('128152') > 0)
                          _buildEmojiTab(codeToEmojiMap['128152']!,
                              countInteractions('128152')),
                        if (countInteractions('128525') > 0)
                          _buildEmojiTab('😍', countInteractions('128525')),
                        if (countInteractions('10024') > 0)
                          _buildEmojiTab('✨', countInteractions('10024')),
                        if (countInteractions('127881') > 0)
                          _buildEmojiTab(codeToEmojiMap['127881']!,
                              countInteractions('127881')),
                        if (countInteractions('128079') > 0)
                          _buildEmojiTab(codeToEmojiMap['128079']!,
                              countInteractions('128079')),
                        if (countInteractions('129000') > 0)
                          _buildEmojiTab(codeToEmojiMap['129000']!,
                              countInteractions('129000')),
                        if (countInteractions('128564') > 0)
                          _buildEmojiTab(codeToEmojiMap['128564']!,
                              countInteractions('128564')),
                        if (countInteractions('128545') > 0)
                          _buildEmojiTab(codeToEmojiMap['128545']!,
                              countInteractions('128545')),
                        if (countInteractions('10060') > 0)
                          _buildEmojiTab(codeToEmojiMap['10060']!,
                              countInteractions('10060')),
                        if (countInteractions('129326') > 0)
                          _buildEmojiTab(codeToEmojiMap['129326']!,
                              countInteractions('129326')),
                        if (countInteractions('128169') > 0)
                          _buildEmojiTab(codeToEmojiMap['128169']!,
                              countInteractions('128169')),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        child: TabBarView(
                          // controller: _tabController,
                          children: [
                            _buildInteractionsList(this.interactions),
                            if (countInteractions('L') > 0)
                              _buildInteractionsList(interactionsMap['L']!),
                            if (countInteractions('D') > 0)
                              _buildInteractionsList(interactionsMap['D']!),
                            if (countInteractions('128175') > 0)
                              _buildInteractionsList(
                                  interactionsMap['128175']!),
                            if (countInteractions('128152') > 0)
                              _buildInteractionsList(
                                  interactionsMap['128152']!),
                            if (countInteractions('128525') > 0)
                              _buildInteractionsList(
                                  interactionsMap['128525']!),
                            if (countInteractions('10024') > 0)
                              _buildInteractionsList(interactionsMap['10024']!),
                            if (countInteractions('127881') > 0)
                              _buildInteractionsList(
                                  interactionsMap['127881']!),
                            if (countInteractions('128079') > 0)
                              _buildInteractionsList(
                                  interactionsMap['128079']!),
                            if (countInteractions('129000') > 0)
                              _buildInteractionsList(
                                  interactionsMap['129000']!),
                            if (countInteractions('128564') > 0)
                              _buildInteractionsList(
                                  interactionsMap['128564']!),
                            if (countInteractions('128545') > 0)
                              _buildInteractionsList(
                                  interactionsMap['128545']!),
                            if (countInteractions('10060') > 0)
                              _buildInteractionsList(interactionsMap['10060']!),
                            if (countInteractions('129326') > 0)
                              _buildInteractionsList(
                                  interactionsMap['129326']!),
                            if (countInteractions('128169') > 0)
                              _buildInteractionsList(
                                  interactionsMap['128169']!),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTab(String label, int count) {
    return Tab(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1, vertical: 8.0),
        child: Row(
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

  Widget _buildInteractionsList(List<dynamic> interactions) {
    print(interactions);
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
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 26.0,
                      ),
                      child: _buildInteractionIcon(
                          interaction['interaction_type']!, ""),
                    ),
                    SizedBox(width: 8.0),
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

  Widget _buildInteractionIcon(String interactionType, String? emojiCode) {
    switch (interactionType) {
      case 'L':
        return Icon(Icons.thumb_up, color: Colors.white, size: 16.0);
      case 'D':
        return Icon(Icons.thumb_down, color: Colors.white, size: 16.0);
      case "10024":
        return Text("✨", style: TextStyle(fontSize: 16));
      case "128175":
        return Text("💯", style: TextStyle(fontSize: 16));
      case "128525":
        return Text("😍", style: TextStyle(fontSize: 16));
      case "128152":
        return Text("💘", style: TextStyle(fontSize: 16));
      case "127881":
        return Text("🎉", style: TextStyle(fontSize: 16));
      case "128079":
        return Text("👏", style: TextStyle(fontSize: 16));
      case "129000":
        return Text("🟨", style: TextStyle(fontSize: 16));
      case "128564":
        return Text("😴", style: TextStyle(fontSize: 16));
      case "128545":
        return Text("😡", style: TextStyle(fontSize: 16));
      case "10060":
        return Text("❌", style: TextStyle(fontSize: 16));
      case "129326":
        return Text("🤮", style: TextStyle(fontSize: 16));
      case "128169":
        return Text("💩", style: TextStyle(fontSize: 16));
      default:
        return SizedBox.shrink();
    }
  }
}
