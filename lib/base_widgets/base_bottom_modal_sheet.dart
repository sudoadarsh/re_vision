import 'package:flutter/material.dart';

class BaseBottomModalSheet extends StatelessWidget {
  const BaseBottomModalSheet({
    Key? key,
    required this.context,
    required this.child,
  }) : super(key: key);

  final BuildContext context;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: child,
      ),
    );
  }
}
