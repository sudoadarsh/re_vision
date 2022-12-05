import "package:flutter/material.dart";

class BaseDivider extends StatelessWidget {
  const BaseDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Divider(thickness: 1, indent: 10.0, endIndent: 10.0),
    );
  }
}
