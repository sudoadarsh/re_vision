import 'package:flutter/material.dart';

import '../../../base_widgets/base_text.dart';
import '../../../constants/icon_constants.dart';
import '../../../constants/string_constants.dart';
import '../../../routes/route_constants.dart';

class DBAppBar extends StatelessWidget {
  const DBAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar.large(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: const BaseText(StringC.dashboard),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(RouteC.homePage, (route) => false);
          },
          child: Row(
            children: const [
              BaseText(StringC.appName),
              IconC.arrowF
            ],
          ),
        ),
      ],
    );
  }
}
