import 'package:flutter/material.dart';
import 'package:re_vision/base_widgets/base_depth_form_field.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';

import '../../base_widgets/base_text.dart';
import '../../constants/icon_constants.dart';
import '../../constants/string_constants.dart';
import '../../models/attachment_dm.dart';

class AddAttachmentPage extends StatefulWidget {
  const AddAttachmentPage({Key? key}) : super(key: key);

  @override
  State<AddAttachmentPage> createState() => _AddAttachmentPageState();
}

class _AddAttachmentPageState extends State<AddAttachmentPage> {

  // Text editing controller for the past link here text field.
  late final TextEditingController _pasteLinkController;

  @override
  void initState() {
    _pasteLinkController = TextEditingController();
    super.initState();
  }

  // The list of available attachment types.
  static final List<AttachmentDm> _attachmentList = [
    AttachmentDm(title: StringConstants.article, icon: IconConstants.article),
    AttachmentDm(title: StringConstants.image, icon: IconConstants.image),
    AttachmentDm(title: StringConstants.pdf, icon: IconConstants.pdf),
    AttachmentDm(title: StringConstants.video, icon: IconConstants.video),
  ];

  // Boolean to control the current widget in the modal bottom sheet.
  bool _articleSelected = false;


  // The list of view of attachments.
  Widget _body() {
    return StatefulBuilder(
      builder: (context, sst) {
        // When the user taps on article, change the widget to text form field.
        return !_articleSelected ?  ListView.builder(
          shrinkWrap: true,
          itemCount: _attachmentList.length,
          itemBuilder: (context, index) {
            AttachmentDm attachment = _attachmentList[index];
            return ListTile(
              onTap: () {
                // If the user taps on [Article].
                if (attachment.isArticle) {
                  sst(() {
                    _articleSelected = true;
                  });
                }
              },
              leading: attachment.icon,
              title: BaseText(attachment.title ?? ''),
            );
          },
        ) : _pasteLink(sst);
      },
    );
  }

  // Paste link here text form field.
  Widget _pasteLink(void Function(void Function()) sst) {
    return Column(
      children: [
        ListTile(
          leading: _attachmentList[0].icon,
          title: BaseText(_attachmentList[0].title ?? ''),
        ),
        BaseTextFormFieldWithDepth(
          maxLines: 3,
          hintText: StringConstants.pasteTheLinkHere,
          controller: _pasteLinkController,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Cancel the the addition of article.
            TextButton(
              onPressed: () {
                sst(() {
                  _articleSelected = false;
                });
              },
              child: const BaseText(StringConstants.cancel,
                  color: ColorConstants.secondary),
            ),
            // Save the article.
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_pasteLinkController.text);
              },
              child: const BaseText(StringConstants.save,
                  color: ColorConstants.primary),
            )
          ],
        ),
      ],
    ).paddingDefault();
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }
}
