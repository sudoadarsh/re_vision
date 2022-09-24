import 'package:flutter/material.dart';

class BaseElevatedButton extends StatelessWidget {
  const BaseElevatedButton(
      {Key? key,
      required this.onPressed,
      required this.child,
      this.backgroundColor,
      this.elevation, this.size})
      : super(key: key);

  final VoidCallback onPressed;
  final Widget child;
  final Color? backgroundColor;
  final double? elevation;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        elevation: elevation,
        minimumSize: size?? const Size(100, 55),
      ),
      child: child,
    );
  }
}
