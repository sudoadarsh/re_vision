import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/base_widgets/expandable_fab.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/double_extensions.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/modules/topic_page/topic_page_v1.dart';

import '../../base_widgets/base_skeleton_dialog.dart';
import '../../base_widgets/base_underline_field.dart';
import '../../constants/size_constants.dart';
import '../../models/attachment_data_dm.dart';
import '../../state_management/attachment/attachment_cubit.dart';

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
          onPressed: () {
            _pickFile(
              allowedExtensions: ["jpg", "jpeg", "jfif", "pjpeg", "pjp", "png"],
              fileType: AttachmentType.image.value,
            );
          },
          icon: IconC.image,
        ),
        ExpandableFABActionButton(
          color: ColorC.secondary,
          onPressed: _pasteLink,
          icon: IconC.link,
        ),
        ExpandableFABActionButton(
          color: ColorC.secondary,
          onPressed: () {
            _pickFile(
              allowedExtensions: ["mp4", "mov", "wmv", "avi"],
              fileType: AttachmentType.video.value,
            );
          },
          icon: IconC.video,
        ),
        ExpandableFABActionButton(
          color: ColorC.secondary,
          onPressed: () {
            _pickFile(
              allowedExtensions: ["pdf", "xlsx", "docx", "pptx"],
              fileType: AttachmentType.pdf.value,
            );
          },
          icon: IconC.pdf,
        ),
      ],
    );
  }

  // ------------------------------- Class methods -----------------------------

  /// To Paste url links.
  Future<void> _pasteLink() async {
    return await showDialog(
      context: context,
      builder: (context) => const BaseSkeletonDialog(
        title: StringC.saveArticles,
        customContent:
            SizedBox(width: double.maxFinite, child: _PasteLinkDropdown()),
        contentPadding: EdgeInsets.only(left: 24.0),
        actionsPadding: SizeC.zeroPadding,
        actions: [],
      ),
    );
  }

  // todo: add info plist permissions.
  // To pick a file.
  Future<void> _pickFile({
    required List<String> allowedExtensions,
    required int fileType,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();

      List<AttachmentDataDm> data = files
          .map((e) => AttachmentDataDm(data: e.path, type: fileType))
          .toList();

      for (AttachmentDataDm element in data) {
        if (!mounted) return;
        context.read<AttachmentCubit>().addAttachment(element);
      }
    } else {
      // todo: User canceled the picker
    }
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

class _PasteLinkDropdown extends StatefulWidget {
  const _PasteLinkDropdown({Key? key}) : super(key: key);

  @override
  State<_PasteLinkDropdown> createState() => _PasteLinkDropdownState();
}

class _PasteLinkDropdownState extends State<_PasteLinkDropdown> {
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
                // Closing the keyboard.
                FocusScope.of(context).unfocus();

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
