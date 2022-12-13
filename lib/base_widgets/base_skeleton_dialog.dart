import 'package:flutter/material.dart';

import 'base_text.dart';

class BaseSkeletonDialog extends StatelessWidget {
  const BaseSkeletonDialog({
    Key? key,
    required this.title,
    this.description,
    this.actions,
    this.customContent,
    this.actionsPadding, this.contentPadding
  }) : super(key: key);

  final String title;
  final String? description;
  final Widget? customContent;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? actionsPadding;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: BaseText(title, textAlign: TextAlign.center),
      content: customContent ??
          BaseText(
            description ?? '',
          ),
      actionsPadding: actionsPadding,
      contentPadding: contentPadding,
      actions: actions ??
          <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: BaseText(
                'Ok',
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
    );
  }
}
