import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_vision/extensions/double_extensions.dart';
import 'package:re_vision/extensions/widget_extensions.dart';

import '../../../base_widgets/base_text.dart';
import '../../../base_widgets/base_underline_field.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/icon_constants.dart';
import '../../../constants/string_constants.dart';
import '../../../models/attachment_data_dm.dart';
import '../../../state_management/attachment/attachment_cubit.dart';

class PasteLinkDropdown extends StatefulWidget {
  const PasteLinkDropdown({Key? key}) : super(key: key);

  @override
  State<PasteLinkDropdown> createState() => _PasteLinkDropdownState();
}

class _PasteLinkDropdownState extends State<PasteLinkDropdown> {
  late List<BaseUnderlineField> _fields;
  late List<TextEditingController> _controller;

  // Form key to validate the text fields.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controller = [TextEditingController()];
    _fields = [_field(_controller[0])];
    super.initState();
  }

  @override
  void dispose() {
    for (TextEditingController controller in _controller) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Form(
            key: _formKey,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _fields.length,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(child: _fields[index]),
                    index == 0
                        ? 50.0.separation(false)
                        : IconButton(
                            onPressed: () {
                              _fields.removeAt(index);
                              _controller.removeAt(index);
                              setState(() {});
                            },
                            icon: IconC.delete,
                          ),
                  ],
                );
              },
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            TextEditingController controller = TextEditingController();
            BaseUnderlineField field = _field(controller);

            _controller.add(controller);
            _fields.add(field);

            setState(() {});
          },
          icon: IconC.add,
        ).center(),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Close the dialog.
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const BaseText(
                StringC.cancel,
                color: ColorC.secondary,
              ),
            ),
            // Save the added links.
            TextButton(
              onPressed: _saveLink,
              child: const BaseText(
                StringC.save,
                color: ColorC.primary,
              ),
            ),
          ],
        ).alignRight(),
      ],
    );
  }

  BaseUnderlineField _field(TextEditingController controller) {
    return BaseUnderlineField(
      hintText: StringC.pasteTheLinkHere,
      controller: controller,
      validator: (value) {
        if ((Uri.tryParse(value ?? '')?.hasAbsolutePath) ?? false) {
          return null;
        } else {
          return StringC.invalidUrl;
        }
      },
    );
  }

  // --------------------------------Functions----------------------------------
  void _saveLink() {
    if (_formKey.currentState?.validate() ?? false) {
      List<AttachmentDataDm> data = _controller
          .where((element) => element.text.isNotEmpty)
          .map((e) => AttachmentDataDm(
              type: AttachmentType.article.value, data: e.text))
          .toList();
      for (AttachmentDataDm element in data) {
        context.read<AttachmentCubit>().addAttachment(element);
      }
      Navigator.of(context).pop();
    }
  }
}
