import 'package:flutter/cupertino.dart';

class DecorationConstants {
  /// Gives circle shape to the widget.
  static const BoxDecoration circleShape =
      BoxDecoration(shape: BoxShape.circle);

  /// Gives rounded border to top of a widget. Is passed to parameter [ShapeBorder].
  static const RoundedRectangleBorder roundedRectangleBorderTop =
      RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(10.0),
      topLeft: Radius.circular(10.0),
    ),
  );

  /// Gives rounded border to bottom of a widget. Is passed to parameter [ShapeBorder].
  static const RoundedRectangleBorder roundedRectangleBorderBottom =
      RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomRight: Radius.circular(10.0),
      bottomLeft: Radius.circular(10.0),
    ),
  );

  /// Gives rounded border to a widget. Is passed to parameter [ShapeBorder].
  static const RoundedRectangleBorder roundedRectangleBorder =
      RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  );
}
