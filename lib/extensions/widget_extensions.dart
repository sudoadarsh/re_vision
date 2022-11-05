import 'package:flutter/cupertino.dart';

extension WidgetEx on Widget {
  // Padding extensions.
  Widget paddingDefault() =>
      Padding(padding: const EdgeInsets.all(8.0), child: this);

  Widget paddingAll16() => Padding(padding: const EdgeInsets.all(16.0), child: this);

  Widget paddingAll4() =>
      Padding(padding: const EdgeInsets.all(4.0), child: this);

  Widget paddingVertical8() =>
      Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: this);

  Widget paddingHorizontal8() =>
      Padding(padding: const EdgeInsets.all(8.0), child: this);

  Widget paddingLeft8() =>
      Padding(padding: const EdgeInsets.only(left: 8.0), child: this);

  Widget paddingTop8() =>
      Padding(padding: const EdgeInsets.only(top: 8.0), child: this);

  Widget paddingOnly(
          {double? top, double? bottom, double? left, double? right}) =>
      Padding(
          padding: EdgeInsets.only(
              top: top ?? 0.0,
              bottom: bottom ?? 0.0,
              right: right ?? 0.0,
              left: left ?? 0.0),
          child: this);

  // Center a widget.
  Widget center() => Center(child: this);

  // Alignment extension.
  Widget alignCenter() => Align(child: this);

  Widget alignRight() => Align(alignment: Alignment.centerRight, child: this);
}
