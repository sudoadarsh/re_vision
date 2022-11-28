import 'package:flutter/material.dart';
import 'package:re_vision/models/topic_dm.dart';

import '../../base_widgets/base_text.dart';

/// Redirected here from the dashboard. Can be either missed or completed
/// revision list.
///
class OverViewPage extends StatelessWidget {
  const OverViewPage({
    Key? key,
    required this.topics,
    this.isCompleted = true, required this.title,
  }) : super(key: key);

  final List<TopicDm> topics;
  final bool isCompleted;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BaseText(title),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: topics.length,
          itemBuilder: (context, i) {
            return Card(
              child: ListTile(
                title: BaseText(topics[i].topic ?? ""),
              ),
            );
          }
      ),
    );
  }
}
