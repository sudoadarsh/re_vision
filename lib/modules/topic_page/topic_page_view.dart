import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:re_vision/constants/decoration_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/modules/topic_page/topic_page_v1.dart';

mixin TopicPageView on State<TopicPageV1> {
  /// The app bar title.
  PreferredSizeWidget title(TextEditingController controller) {
    return _Title(
      titleC: controller,
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
  /// The items of attachments dropdown.
  late final List<String> _dropdownItems;

  @override
  void initState() {
    super.initState();

    _dropdownItems = ["Image", "Pdf", "Video", "Article"];

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
        IconButton(onPressed: () {}, icon: IconC.folder),
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            dropdownWidth: 100,
            dropdownDecoration: DecorC.boxDecorAll(radius: 10.0),
            selectedItemBuilder: (_) {
              return _dropdownItems
                  .map((e) => const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0)))
                  .toList();
            },
            items: _dropdownItems
                .map<DropdownMenuItem<String>>((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.toString()),
                    ))
                .toList(),
            onChanged: (val) {},
            icon: IconC.attachments,
            iconEnabledColor: Colors.black,
            iconDisabledColor: Colors.black,
          ).paddingOnly(right: 8.0),
        )
      ],
    );
  }
}
