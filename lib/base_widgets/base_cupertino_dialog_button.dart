import 'package:flutter/material.dart';
import 'package:re_vision/extensions/widget_extensions.dart';

import 'base_text.dart';

class BaseCupertinoDialogButton extends StatelessWidget {
  const BaseCupertinoDialogButton({
    Key? key,
    required this.onTap,
    required this.title,
    this.color,
  }) : super(key: key);

  final VoidCallback onTap;
  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          child: BaseText(title, color: color).center(),
        ),
      ),
    );
  }
}
