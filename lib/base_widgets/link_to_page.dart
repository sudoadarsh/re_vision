import 'package:flutter/material.dart';

import 'base_text.dart';

class LinkToPage extends StatelessWidget {
  const LinkToPage({
    Key? key,
    required this.title,
    required this.pageName,
    required this.route,
  }) : super(key: key);

  final String title;
  final String pageName;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BaseText(title),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(route);
          },
          child: BaseText(pageName),
        )
      ],
    );
  }
}
