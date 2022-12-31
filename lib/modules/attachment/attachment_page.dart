import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/modules/attachment/widgets/attachment_thumbnail.dart';
import 'package:re_vision/utils/app_config.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../base_widgets/base_text.dart';
import '../../constants/icon_constants.dart';
import '../../constants/string_constants.dart';
import '../../models/attachment_data_dm.dart';
import '../../state_management/attachment/attachment_cubit.dart';
import 'attachment_view.dart';

enum Attachments {
  all(4),
  article(0),
  image(1),
  pdf(2),
  video(3);

  const Attachments(this.value);

  final int value;
}

class AttachmentPage extends StatefulWidget {
  const AttachmentPage({Key? key}) : super(key: key);

  @override
  State<AttachmentPage> createState() => _AttachmentPageState();
}

class _AttachmentPageState extends State<AttachmentPage> with AttachmentView {
  /// The currently selected Attachment.
  late Attachments _currentAttachment;

  @override
  void initState() {
    super.initState();

    _currentAttachment = Attachments.all;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BaseText(StringC.addAttachment),
        actions: [
          attachmentDropdown(
            onChanged: (val) async {
              switch (val) {
                case Attachments.image:
                  pickFile(
                    allowedExtensions: ["jpg", "jpeg", "pjp", "png"],
                    fileType: Attachments.image.value,
                  );
                  break;
                case Attachments.video:
                  pickFile(
                    allowedExtensions: ["mp4", "mov", "wmv", "avi"],
                    fileType: Attachments.video.value,
                  );
                  break;
                case Attachments.pdf:
                  pickFile(
                    allowedExtensions: ["pdf", "xlsx", "docx", "pptx"],
                    fileType: Attachments.pdf.value,
                  );
                  break;
                case Attachments.article:
                  await pasteLink();
                  break;
                default:
                  break;
              }
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /// Filter chips.
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: Attachments.values.length,
              itemBuilder: (context, i) {
                return attachmentChip(
                  value: Attachments.values[i],
                  groupValue: _currentAttachment,
                  onTap: (val) {
                    _currentAttachment = val;
                    setState(() {});
                  },
                );
              },
            ),
          ),
          Flexible(child: BlocBuilder<AttachmentCubit, AttachmentState>(
            builder: (context, state) {

              // The filtered data.
              List<AttachmentDataDm> rData = _filterAttachment(state.data);

              return rData.isNotEmpty
                  ? GridView.builder(
                      gridDelegate: _gridDelegate(context),
                      itemCount: rData.length,
                      itemBuilder: (context, i) {
                        return Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            attachmentGrid(
                              child: Container(
                                decoration: const BoxDecoration(boxShadow: [
                                  BoxShadow(
                                    color: ColorC.shadowColor,
                                    blurRadius: 3,
                                    spreadRadius: 1,
                                    offset: Offset(5, 5),
                                  ),
                                ]),
                                child: _getAttachmentPreview(rData[i]),
                              ),
                              onTap: () => _onAttachmentGridTap(rData[i]),
                            ),
                            deleteLabel(rData[i]),
                          ],
                        );
                      },
                    ).paddingHorizontal8()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(StringC.noAttachmentsPath, scale: 4),
                        const BaseText(StringC.noAttachmentsAdded)
                      ],
                    );
            },
          )),
        ],
      ),
    );
  }

  // ---------------------------- Class methods --------------------------------

  SliverGridDelegate _gridDelegate(BuildContext context) {
    return const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
    );
  }

  /// To filter the attachments according the filter selected.
  List<AttachmentDataDm> _filterAttachment(
      List<AttachmentDataDm> receivedData) {
    if (_currentAttachment == Attachments.all) return receivedData;
    return receivedData
        .where((element) => element.type == _currentAttachment.value)
        .toList();
  }

  /// On attachment Grid tap.
  void _onAttachmentGridTap(AttachmentDataDm data) {
    if (data.type == 0) {
      // Open Link.
      try {
        launchUrl(Uri.parse(data.data ?? ''), mode: LaunchMode.inAppWebView);
      } catch (e) {
        debugPrint('Error launching web-view.');
        // todo: add error dialog.
        debugPrint(e.toString());
      }
    } else {
      // Open file.
      if (File(data.data ?? '').existsSync()) {
        OpenFilex.open(data.data ?? '');
      } else {
        // todo: add image fetch failed dialog.
        debugPrint("Image path doesn't exist");
      }
    }
  }

  Widget _getAttachmentPreview(AttachmentDataDm data) {
    if (data.type == 0) {
      return articleAttachment(data.data ?? "");
    } else if (data.type == 1) {
      return Image.file(
        File(data.data ?? ""),
        fit: BoxFit.fill,
        width: AppConfig.width(context) * 0.5,
        height: AppConfig.height(context) * 0.3,
      );
    } else if (data.type == 2) {
      return IconC.pdf.center();
    } else if (data.type == 3) {
      return AttachmentThumbnail(path: data.data ?? "");
    }

    return SizeC.none;
  }
}
