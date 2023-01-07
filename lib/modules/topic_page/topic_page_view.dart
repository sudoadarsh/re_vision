import 'package:flutter/material.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/modules/topic_page/topic_page_v1.dart';

mixin TopicPageView on State<TopicPageV1> {
  /// The app bar title.
  PreferredSizeWidget title({
    required TextEditingController controller,
    required VoidCallback? onSaveTap,
    required FocusNode focusNode,
  }) {
    return _Title(
      titleC: controller, onTap: onSaveTap, focusNode: focusNode,
    );
  }
}

class _Title extends StatefulWidget with PreferredSizeWidget {
  const _Title({
    Key? key,
    required this.titleC, required this.onTap, required this.focusNode,
  }) : super(key: key);

  final TextEditingController titleC;
  final VoidCallback? onTap;
  final FocusNode focusNode;

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
        focusNode: widget.focusNode,
        controller: widget.titleC,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          hintText: StringC.addTopic,
        ),
      ),
      actions: [
        TextButton(onPressed: widget.onTap, child: const BaseText(StringC.save))
      ],
    );
  }
}
