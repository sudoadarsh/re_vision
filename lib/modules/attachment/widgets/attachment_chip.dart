import 'package:flutter/material.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/modules/attachment/attachment_page.dart';

import '../../../base_widgets/base_text.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/icon_constants.dart';

class AttachmentChip extends StatelessWidget {
  const AttachmentChip({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.desc, required this.onTap,
  }) : super(key: key);

  final Attachments value;
  final Attachments groupValue;

  final String desc;
  final Function(Attachments) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      onTap: ()=> onTap(value),
      child: Chip(
        avatar: value == groupValue
            ? const CircleAvatar(
                backgroundColor: ColorC.white,
                foregroundColor: ColorC.primary,
                child: IconC.complete,
              )
            : null,
        backgroundColor:
            value == groupValue ? ColorC.secondary : ColorC.secondaryComp,
        label: BaseText(desc),
      ).paddingOnly(left: 4.0, right: 8.0),
    );
  }
}
