import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:re_vision/extensions/enum_extension.dart';

import '../../../base_widgets/base_text.dart';
import '../../../constants/decoration_constants.dart';
import '../../../constants/icon_constants.dart';
import '../attachment_page.dart';

class AttachmentDropdown extends StatefulWidget {
  const AttachmentDropdown({Key? key, required this.onChanged}) : super(key: key);

  final Function(Attachments?) onChanged;

  @override
  State<AttachmentDropdown> createState() => _AttachmentDropdownState();
}

class _AttachmentDropdownState extends State<AttachmentDropdown> {

  List<Attachments> values = [];

  @override
  void initState() {
    super.initState();

    values.addAll(Attachments.values);
    values.remove(Attachments.all);
  }

  @override
  Widget build(BuildContext context) {
    return  DropdownButtonHideUnderline(
      child: Theme(
        data: ThemeData(splashColor: Colors.transparent),
        child: DropdownButton2<Attachments>(
          buttonPadding: const EdgeInsets.only(right: 8.0),
          icon: IconC.add,
          value: null,
          dropdownDecoration: DecorC.boxDecorAll(radius: 10.0),
          items: values
              .map((e) => DropdownMenuItem<Attachments>(
            value: e,
            child: BaseText(e.desc()),
          ))
              .toList(),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
