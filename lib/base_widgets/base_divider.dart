import "package:flutter/material.dart";

class BaseDivider extends StatelessWidget {
  const BaseDivider({Key? key, this.color}) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Divider(thickness: 1, indent: 10.0, endIndent: 10.0, color: color),
    );
  }
}
