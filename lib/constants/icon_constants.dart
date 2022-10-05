import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  static const Icon visible =
      Icon(Icons.visibility, color: ColorConstants.primary);
  static const Icon visibilityOff =
      Icon(Icons.visibility_off, color: ColorConstants.primary);

  // Icons used in the home page.
  static const Icon add = Icon(Icons.add);
  static const Icon complete = Icon(Icons.done, color: ColorConstants.primary);
  static const Icon delete =
      Icon(Icons.delete, color: ColorConstants.secondary);

  // Icons used in the topic page.
  static const Icon article = Icon(Icons.article_outlined);
  static const Icon video = Icon(Icons.video_library_outlined);
  static const Icon image = Icon(Icons.image_outlined);
  static const Icon pdf = Icon(Icons.picture_as_pdf_outlined);
  static const Icon link = Icon(Icons.link);
  static const Widget close = CircleAvatar(
    radius: 18,
    backgroundColor: ColorConstants.secondary,
    child: Icon(Icons.close, color: ColorConstants.white, size: 18),
  );
  static final Widget noFavIcon = Image.asset(
    StringConstants.noFavIcon,
    scale: 15,
  );
  static const Icon save = Icon(Icons.save_outlined, color: ColorConstants.primary);
  static const FaIcon expand = FaIcon(FontAwesomeIcons.angleDown);
  static const FaIcon collapse = FaIcon(FontAwesomeIcons.angleUp);
}
