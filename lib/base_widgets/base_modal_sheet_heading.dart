import 'package:flutter/material.dart';

import 'base_text.dart';

class BaseBMSHeading extends StatelessWidget {
  const BaseBMSHeading({Key? key, required this.heading}) : super(key: key);

  final String heading;

  @override
  Widget build(BuildContext context) {
    return BaseText(
      heading,
      fontWeight: FontWeight.w500,
      fontSize: 18.0,
    );
  }
}
