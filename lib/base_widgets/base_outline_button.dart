import 'package:flutter/material.dart';

class BaseOutlineButton extends StatelessWidget {
  const BaseOutlineButton({
    Key? key,
    required this.child,
    required this.borderColor,
    required this.onPressed, this.backgroundColor,
  }) : super(key: key);

  final Widget child;
  final Color borderColor;
  final VoidCallback onPressed;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: borderColor),
        backgroundColor: backgroundColor,
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
