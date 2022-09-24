import 'package:flutter/material.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/string_constants.dart';

class IconConstants {
  // Icons used in the login page.
  static const Icon username = Icon(
    Icons.person,
    color: ColorConstants.primary,
  );
  static const Icon password = Icon(Icons.lock, color: ColorConstants.primary);
  static final Widget google = Image.asset(
    StringConstants.googlePath,
    scale: 15,
  );
  static final Widget apple = Image.asset(
    StringConstants.applePath,
    scale: 15,
  );


  // Icons used in the home page.
  static const Icon add = Icon(Icons.add);
}
