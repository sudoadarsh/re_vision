import 'package:flutter/cupertino.dart';

extension WidgetEx on Widget {
  Widget paddingDefault() =>
      Padding(padding: const EdgeInsets.all(8.0), child: this);
}
