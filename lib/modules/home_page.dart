import 'package:flutter/material.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/string_constants.dart';

/// [HomePage] is the first page of the application. The below widgets are
/// coded in the order that they appear the ui.
///
class _AppBar extends StatelessWidget {
  const _AppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const BaseText(StringConstants.empty),
      actions: [
        IconButton(
          onPressed: () {},
          icon: IconConstants.add,
          color: ColorConstants.primary,
        )
      ]
    );
  }
}


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _AppBar(),
    );
  }
}
