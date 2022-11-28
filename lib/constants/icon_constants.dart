import 'package:flutter/material.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/string_constants.dart';

class IconC {
  // The main logo.
  static final Widget mainLogo = Image.asset(StringC.logoPath, scale: 8);
  static final Widget mainLogoMin = Image.asset(StringC.logoPath, scale: 15);

  // Icons used in the login page.
  static const Icon email = Icon(
    Icons.email,
    color: ColorC.primary,
  );
  static const Icon user = Icon(
    Icons.person,
    color: ColorC.primary,
  );
  static const Icon password = Icon(Icons.lock, color: ColorC.primary);
  static final Widget google = Image.asset(
    StringC.googlePath,
    scale: 15,
  );
  static final Widget apple = Image.asset(
    StringC.applePath,
    scale: 15,
  );
  static const Icon visible = Icon(Icons.visibility, color: ColorC.primary);
  static const Icon visibilityOff =
      Icon(Icons.visibility_off, color: ColorC.primary);

  // Icons used in the dashboard.
  static const Icon dashboard = Icon(Icons.dashboard_customize_rounded);
  static const Icon settings = Icon(Icons.settings);
  static const Icon notification = Icon(Icons.favorite);
  static const Icon search = Icon(Icons.search);
  static const Icon profile = Icon(
    Icons.person_pin,
    color: ColorC.white,
  );
  static final Widget star = Image.asset(StringC.starPath);
  static const Icon progress = Icon(Icons.auto_graph_rounded);

  // Icons used in the home page.
  static const Icon add = Icon(Icons.add, color: ColorC.primary);
  static const Icon complete = Icon(Icons.done, color: ColorC.primary);
  static const Icon delete = Icon(Icons.delete, color: ColorC.secondary);
  static const Icon share = Icon(Icons.share, color: Colors.cyan);
  static const Icon attachments = Icon(Icons.attachment);
  static Widget userGrp = Image.asset(StringC.userGrpPath, scale: 15.0);
  static const Icon arrowB = Icon(Icons.chevron_left);
  static const Icon arrowF = Icon(Icons.chevron_right);
  static const Icon goToToday = Icon (Icons.my_location);

  // Icons used in the topic page.
  static const Icon article = Icon(Icons.article_outlined);
  static const Icon video = Icon(Icons.video_library_outlined);
  static const Icon image = Icon(Icons.image_outlined);
  static const Icon pdf = Icon(Icons.picture_as_pdf_outlined);
  static const Icon link = Icon(Icons.link);
  static const Icon close = Icon(Icons.close);
  static final Widget noFavIcon = Image.asset(
    StringC.noFavIconPath,
    scale: 15,
  );
  static const Icon save = Icon(Icons.save_outlined, color: ColorC.primary);
  static const Icon expand = Icon(Icons.keyboard_arrow_down_rounded);
  static const Icon collapse = Icon(Icons.keyboard_arrow_up_rounded);
  static const Icon success = Icon(Icons.check_circle, color: ColorC.primary);
  static const Icon failed = Icon(Icons.info, color: ColorC.secondary);
  static const Icon edit = Icon(Icons.edit);

  // Icon constants in the profile page.
  static const Icon pfCardTrailing = Icon(Icons.arrow_forward_ios);
  static const Icon logout = Icon(Icons.logout, color: ColorC.secondary);

  // Icon constants in the invites page.
  static const Icon calendar = Icon(Icons.calendar_month);

  // Icon constants in the overview page.
  static const Icon reschedule = Icon(Icons.restart_alt_rounded);
}
