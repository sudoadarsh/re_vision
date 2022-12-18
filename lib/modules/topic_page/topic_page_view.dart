import 'package:flutter/material.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/base_widgets/exapandable_fab.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/modules/topic_page/topic_page_v1.dart';

mixin TopicPageView on State<TopicPageV1> {
  /// The app bar title.
  PreferredSizeWidget title(TextEditingController controller) {
    return _Title(
      titleC: controller,
    );
  }

  /// The expandable FAB.
  Widget expandableFab() {
    return ExpandableFab(
      color: ColorC.primary,
      distance: 112.0,
      children: [
        ExpandableFABActionButton(
          color: ColorC.secondary,
          onPressed: (){},
          icon: IconC.image,
        ),
        ExpandableFABActionButton(
          color: ColorC.secondary,
          onPressed: (){},
          icon: IconC.link,
        ),
        ExpandableFABActionButton(
          color: ColorC.secondary,
          onPressed: (){},
          icon: IconC.video,
        ),
        ExpandableFABActionButton(
          color: ColorC.secondary,
          onPressed: (){},
          icon: IconC.pdf,
        ),
      ],
    );
  }
}

class _Title extends StatefulWidget with PreferredSizeWidget {
  const _Title({
    Key? key,
    required this.titleC,
  }) : super(key: key);

  final TextEditingController titleC;

  @override
  State<_Title> createState() => _TitleState();

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class _TitleState extends State<_Title> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TextFormField(
        controller: widget.titleC,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          hintText: StringC.addTopic,
        ),
      ),
      actions: [
        TextButton(onPressed: () {}, child: const BaseText(StringC.save))
      ],
    );
  }
}
