import 'package:flutter/material.dart';
import 'package:re_vision/constants/string_constants.dart';

import '../../base_widgets/base_elevated_button.dart';
import '../../base_widgets/base_text.dart';

class InvitesPage extends StatelessWidget {
  const InvitesPage({
    Key? key,
    required this.topicInvites,
  }) : super(key: key);

  final List topicInvites;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BaseText(StringC.revisionInvites),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: ListView.builder(
        itemCount: topicInvites.length,
        itemBuilder: (ctx, i) {
          return ListTile(
            title: BaseText(topicInvites[i].topicName ?? ""),
            subtitle: BaseText("From: ${topicInvites[i].email}"),
            trailing: BaseElevatedButton(
              onPressed: () {

              },
              size: const Size(80, 40),
              child: const BaseText(StringC.accept),
            ),
          );
        },
      ),
    );
  }
}
