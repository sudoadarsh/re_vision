import 'package:flutter/material.dart';

import 'base_text.dart';

class LinkToPage extends StatelessWidget {
  const LinkToPage({
    Key? key,
    required this.title,
    required this.pageName,
    this.route,
    this.onTap
  }) : super(key: key);

  final String title;
  final String pageName;
  final String? route;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BaseText(title),
        TextButton(
          onPressed: route == null ? onTap : () {
            Navigator.of(context).pushNamed(route!);
          },
          child: BaseText(pageName),
        )
      ],
    );
  }
}
