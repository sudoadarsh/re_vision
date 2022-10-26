import 'package:flutter/material.dart';
import 'package:re_vision/extensions/widget_extensions.dart';

import '../constants/color_constants.dart';
import '../constants/icon_constants.dart';
import 'base_image_builder.dart';

class BaseInstaStory extends StatelessWidget {
  const BaseInstaStory({
    Key? key,
    required this.imageUrl,
    required this.onTap,
  }) : super(key: key);

  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100,
        width: 100,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [ColorC.primary, ColorC.secondary]),
          shape: BoxShape.circle,
        ),
        child: SizedBox(
          width: 92,
          height: 92,
          child: BaseImageBuilder(
            url: imageUrl,
            boxShape: BoxShape.circle,
            error: IconC.failed,
          ).center(),
        ),
      ),
    );
  }
}
