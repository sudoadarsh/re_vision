import 'package:flutter/material.dart';
import 'package:re_vision/extensions/widget_extensions.dart';

import '../../../base_widgets/base_text.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/decoration_constants.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    Key? key,
    required this.stat,
    required this.subtitle,
    required this.link,
    required this.onLinkTap,
    required this.color,
  }) : super(key: key);

  final int stat;
  final String subtitle;
  final String link;
  final VoidCallback onLinkTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onLinkTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 150),
        child: Container(
          decoration: DecorC.boxDecorAll(radius: 10).copyWith(
            color: color,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseText(
                    stat.toString(),
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: ColorC.white,
                  ),
                  BaseText(subtitle, color: ColorC.white),
                ],
              ).paddingDefault(),
              Positioned(
                top: 2,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BaseText(link, color: ColorC.white),
                    const Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: ColorC.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
