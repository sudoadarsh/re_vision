import 'package:flutter/material.dart';

import 'base_text.dart';

class BaseAlertDialog extends StatelessWidget {
  const BaseAlertDialog({
    Key? key,
    required this.title,
    this.description,
    this.actions,
    this.customContent,
    this.actionsPadding
  }) : super(key: key);

  final String title;
  final String? description;
  final Widget? customContent;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? actionsPadding;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: BaseText(title),
      content: customContent ??
          BaseText(
            description ?? '',
          ),
      actionsPadding: actionsPadding,
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
