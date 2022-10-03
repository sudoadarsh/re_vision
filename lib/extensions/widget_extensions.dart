import 'package:flutter/cupertino.dart';

extension WidgetEx on Widget {
  // Padding extensions.
  Widget paddingDefault() =>
      Padding(padding: const EdgeInsets.all(8.0), child: this);
  Widget paddingAll4() => Padding(padding: const EdgeInsets.all(4.0), child: this);


  // Center a widget.
  Widget center() => Center(child: this);

}
