import 'package:re_vision/modules/dashboard/dashboard_v1_page.dart';
import 'package:flutter/material.dart';
import 'package:re_vision/modules/dashboard/widgets/db_app_bar.dart';
import 'package:re_vision/modules/dashboard/widgets/state_card.dart';

mixin DashBoardView on State<DashboardNavItem> {
  /// The app bar.
  Widget appBar() {
    return const DBAppBar();
  }

  /// The stat cards.
  Widget statCard({
    required int stat,
    required String subtitle,
    required String link,
    required void Function() onLinkTap,
    required Color color,
  }) {
    return StatCard(
      stat: stat,
      subtitle: subtitle,
      link: link,
      onLinkTap: onLinkTap,
      color: color,
    );
  }
}
