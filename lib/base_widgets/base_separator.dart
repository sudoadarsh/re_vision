import 'package:flutter/material.dart';

import 'base_text.dart';

class BaseSeparator extends StatelessWidget {
  const BaseSeparator({Key? key, required this.title}) : super(key: key);

  final String title;

  static const Widget _divider =
  Expanded(child: Divider(thickness: 1, indent: 10.0, endIndent: 10.0));

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _divider,
        BaseText(title),
        _divider,
      ],
    );
  }
}
