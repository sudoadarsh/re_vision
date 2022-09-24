import 'package:flutter/cupertino.dart';

class AppConfig {
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
  }
}
