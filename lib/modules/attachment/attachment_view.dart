import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_vision/extensions/enum_extension.dart';
import 'package:re_vision/modules/attachment/attachment_page.dart';
import 'package:flutter/material.dart';
import 'package:re_vision/modules/attachment/widgets/attachment_article.dart';
import 'package:re_vision/modules/attachment/widgets/attachment_chip.dart';
import 'package:re_vision/modules/attachment/widgets/attachment_dropdown.dart';
import 'package:re_vision/modules/attachment/widgets/attachment_grid.dart';
import 'package:re_vision/modules/attachment/widgets/delete_label.dart';
import 'package:re_vision/modules/attachment/widgets/past_link_dropdown.dart';

import '../../base_widgets/base_skeleton_dialog.dart';
import '../../constants/size_constants.dart';
import '../../constants/string_constants.dart';
import '../../models/attachment_data_dm.dart';
import '../../state_management/attachment/attachment_cubit.dart';

mixin AttachmentView on State<AttachmentPage> {
  /// The attachment chips.
  Widget attachmentChip({
    required Attachments value,
    required Attachments groupValue,
    required Function(Attachments) onTap,
  }) {
    return AttachmentChip(
        value: value, groupValue: groupValue, desc: value.desc(), onTap: onTap);
  }

  /// The attachment dropdown.
  Widget attachmentDropdown({required Function(Attachments?) onChanged}) {
    return AttachmentDropdown(onChanged: onChanged);
  }

  /// The article attachment.
  Widget articleAttachment(String initialUrl) {
    return AttachmentArticle(initialUrl: initialUrl);
  }

  /// The transparent Label over the attachment with the delete button.
  Widget deleteLabel(AttachmentDataDm data) {
    return DeleteLabel(data: data);
  }

  /// The attachment Grid.
  Widget attachmentGrid({
    required Widget child,
    required VoidCallback onTap,
  }) {
    return AttachmentGrid(onTap: onTap, child: child);
  }

  // ----------------------------- Class methods -------------------------------

  Future<void> pasteLink() async {
    return await showDialog(
      context: context,
      builder: (context) => const BaseSkeletonDialog(
        title: StringC.saveArticles,
        customContent:
            SizedBox(width: double.maxFinite, child: PasteLinkDropdown()),
        contentPadding: EdgeInsets.only(left: 24.0),
        actionsPadding: SizeC.zeroPadding,
        actions: [],
      ),
    );
  }

  // todo: add info plist permissions.
  Future<void> pickFile({
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
