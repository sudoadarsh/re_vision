import 'package:flutter/material.dart';
import 'package:re_vision/extensions/widget_extensions.dart';

import '../constants/decoration_constants.dart';
import 'base_text.dart';

class BaseSocialButton extends StatelessWidget {
  const BaseSocialButton({
    Key? key,
    required this.icon,
    required this.title, required this.onPressed,
  }) : super(key: key);

  final Widget icon;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: DecorationConstants.roundedRectangleBorder,
      color: const Color.fromRGBO(255, 255, 255, 1.0),
      elevation: 4.0,
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [icon, BaseText(' Continue with $title')],
      ).paddingAll4(),
    ).paddingAll4();
  }
}
