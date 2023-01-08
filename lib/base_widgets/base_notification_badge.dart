import 'package:flutter/material.dart';

class BaseNotificationBadge extends StatelessWidget {
  const BaseNotificationBadge({Key? key, this.radius = 8}) : super(key: key);

  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromRGBO(255, 215, 0, 1),
      ),
      height: radius,
      width: radius,
    );
  }
}
