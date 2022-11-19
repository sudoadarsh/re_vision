import 'package:flutter/material.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/decoration_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';

class BaseModalSheetWithNotch extends StatelessWidget {
  const BaseModalSheetWithNotch({
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
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BaseNotch(),
            child
          ],
        ),
      ),
    );
  }
}

class BaseNotch extends StatelessWidget {
  const BaseNotch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 8,
      decoration: DecorC.boxDecorAll(radius: 10.0)
          .copyWith(color: ColorC.shadowColor),
    ).paddingDefault();
  }
}
