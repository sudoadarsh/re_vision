import 'package:flutter/cupertino.dart';

import '../constants/string_constants.dart';
import 'base_text.dart';

class BaseConfirmationDialog extends StatelessWidget {
  const BaseConfirmationDialog({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: BaseText(title),
      content: content,
      actions: [
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const BaseText(StringC.ok),
        ),
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const BaseText(StringC.cancel),
        ),
      ],
    );
  }
}
