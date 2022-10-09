import 'package:flutter/material.dart';
import 'package:re_vision/base_widgets/base_text.dart';

void baseSnackBar(
  BuildContext context, {
  required String message,
  required Widget leading,
  Color? backgroundColor,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor ?? Colors.white,
      content: ListTile(
        leading: leading,
        title: BaseText(message),
        contentPadding: EdgeInsets.zero,
      ),
    ),
  );
}
