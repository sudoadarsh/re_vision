import 'package:flutter/material.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/decoration_constants.dart';

void baseSnackBar(
  BuildContext context, {
  required String message,
  required Widget leading,
  Color? backgroundColor,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: DecorationConstants.roundedRectangleBorder.copyWith(
        side: const BorderSide(color: Colors.black12),
      ),
      padding: const EdgeInsets.all(4.0),
      backgroundColor: backgroundColor ?? Colors.white,
      content: ListTile(
        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
        leading: leading,
        title: BaseText(message),
        contentPadding: EdgeInsets.zero,
      ),
    ),
  );
}
