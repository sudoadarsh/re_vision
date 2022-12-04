import 'package:flutter/cupertino.dart';

class AppConfig {

  /// Height of the screen.
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
  }

  /// Width of the screen.
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Keyboard position.
  static double kbPosition(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }
}
