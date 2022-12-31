import 'package:flutter/material.dart';

import '../../../constants/color_constants.dart';

class AttachmentGrid extends StatelessWidget {
  const AttachmentGrid({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: ColorC.shadowColor)
        ),
        child: child,
      ),
    );
  }
}
