import 'package:flutter/material.dart';
import 'package:re_vision/constants/color_constants.dart';

class CustomThemeData {
  static final ThemeData themeData = ThemeData(
    // Use material 3
    useMaterial3: true,
    // primary color.
    primaryColor: ColorC.primary,
    // scaffold background color.
    scaffoldBackgroundColor: const Color.fromRGBO(227, 243, 245, 1.0),
    // App bar color.
    appBarTheme: const AppBarTheme(color: ColorC.white),
  );
}
