import 'package:flutter/material.dart';

class BaseElevatedRoundedButton extends StatelessWidget {
  const BaseElevatedRoundedButton(
      {Key? key, this.backgroundColor, this.child, required this.onPressed})
      : super(key: key);

  final Color? backgroundColor;
  final Widget? child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: const CircleBorder(),
      ),
      child: child,
    );
  }
}
