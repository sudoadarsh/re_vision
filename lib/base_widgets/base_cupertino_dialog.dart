import 'package:flutter/material.dart';

import 'base_text.dart';

class BaseCupertinoDialog extends StatelessWidget {
  const BaseCupertinoDialog({
    Key? key,
    required this.title,
    this.description,
    required this.actions, this.customContent,
  }) : super(key: key);

  final String title;
  final String? description;
  final Widget? customContent;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: BaseText(title),
      content: customContent ?? BaseText(description ?? ''),
      actionsPadding: const EdgeInsets.only(bottom: 12.0),
      actions: [
        ...actions.map((e) => Column(
            mainAxisSize: MainAxisSize.min, children: [const Divider(), e]))
      ],
    );
  }
}
