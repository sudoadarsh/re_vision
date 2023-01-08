import 'package:flutter/material.dart';

class BaseCircleAvatar extends StatelessWidget {
  const BaseCircleAvatar({
    Key? key,
    this.borderColor,
    this.image,
    required this.radius, this.backgroundColor, this.child,
  }) : super(key: key);

  final Color? borderColor;
  final Color? backgroundColor;
  final DecorationImage? image;
  final double radius;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor ?? Colors.transparent),
        image: image,
      ),
      child: child,
    );
  }
}
