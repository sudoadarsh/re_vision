import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:favicon/favicon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/decoration_constants.dart';
import 'package:re_vision/extensions/enum_extension.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../base_widgets/base_image_builder.dart';
import '../../base_widgets/base_text.dart';
import '../../constants/icon_constants.dart';
import '../../constants/string_constants.dart';
import '../../models/attachment_data_dm.dart';
import '../../state_management/attachment/attachment_cubit.dart';
import 'attachment_view.dart';

enum Attachments {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BaseText(StringC.addAttachment),
        actions: [
          DropdownButtonHideUnderline(
            child: Theme(
              data: ThemeData(splashColor: Colors.transparent),
              child: DropdownButton2(
                buttonPadding: const EdgeInsets.only(right: 8.0),
                icon: IconC.add,
                value: null,
                dropdownDecoration: DecorC.boxDecorAll(radius: 10.0),
                items: Attachments.values
                    .map((e) => DropdownMenuItem<Attachments>(
                          value: e,
                          child: BaseText(e.desc()),
                        ))
                    .toList(),
                onChanged: (val) async {
                  switch (val) {
                    case Attachments.image:
                      pickFile(
                        allowedExtensions: [
                          "jpg",
                          "jpeg",
                          "jfif",
                          "pjpeg",
                          "pjp",
                          "png"
                        ],
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
              ),
            ),
          ),
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
                  return Chip(
                    backgroundColor: ColorC.secondaryComp,
                    label: BaseText(Attachments.values[i].name),
                  ).paddingOnly(left: 4.0, right: 8.0);
                }),
          ),

          Flexible(
            child: BlocBuilder<AttachmentCubit, AttachmentState>(
              builder: (context, state) {
                List<AttachmentDataDm> receivedData = state.data;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: receivedData.length,
                  itemBuilder: (context, i) {
                    return _getTile(receivedData[i]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------- Class methods --------------------------------

  Widget _getTile(AttachmentDataDm e) {
    if (e.type == 0) {
      return _ArticleTile(data: e);
    } else {
      return _CommonTile(data: e);
    }
  }
}

class _ArticleTile extends StatelessWidget {
  const _ArticleTile({Key? key, required this.data}) : super(key: key);

  final AttachmentDataDm data;

  Future<String?> getImageUrl() async {
    String url;
    try {
      final Favicon? icon = await FaviconFinder.getBest(data.data ?? '');
      url = icon?.url ?? '';
    } catch (e) {
      debugPrint('Unable to get Favicon');
      url = '';
    }
    return url;
  }

  String getWebsiteName() {
    String name;
    try {
      final Uri uri = Uri.parse(data.data ?? '');
      name = uri.host;
    } catch (e) {
      debugPrint(e.toString());
      name = '';
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 20,
        height: 20,
        child: FutureBuilder(
          future: getImageUrl(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return BaseImageBuilder(
                url: snapshot.data!,
                error: IconC.link,
                height: 20,
                width: 20,
              ).center();
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const CupertinoActivityIndicator();
            }
            return IconC.link;
          },
        ),
      ),
      title: BaseText(getWebsiteName()),
      subtitle: const BaseText(
        StringC.tapToOpenWeb,
        fontWeight: FontWeight.w300,
        fontSize: 12,
      ),
      trailing: IconButton(
        onPressed: () {
          context.read<AttachmentCubit>().removeAttachment(data);
        },
        icon: IconC.delete,
      ),
      onTap: () {
        try {
          launchUrl(Uri.parse(data.data ?? ''), mode: LaunchMode.inAppWebView);
        } catch (e) {
          debugPrint('Error launching web-view.');
          // todo: add error dialog.
          debugPrint(e.toString());
        }
      },
    );
  }
}

class _CommonTile extends StatelessWidget {
  const _CommonTile({Key? key, required this.data}) : super(key: key);

  final AttachmentDataDm data;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _getLeading(),
      title: BaseText(_getFileName()),
      subtitle: const BaseText(
        StringC.tapToOpenFile,
        fontWeight: FontWeight.w300,
        fontSize: 12,
      ),
      trailing: IconButton(
        icon: IconC.delete,
        onPressed: () {
          context.read<AttachmentCubit>().removeAttachment(data);
          _deleteFile();
        },
      ),
      onTap: () {
        _openFile();
      },
    );
  }

  // To get the leading.
  Widget _getLeading() {
    if (data.type == 1) {
      return IconC.image;
    } else if (data.type == 2) {
      return IconC.pdf;
    } else {
      return IconC.video;
    }
  }

  // To get the image name.
  String _getFileName() {
    return data.data?.split('/').last ?? '';
  }

  // Deleting the image from cache.
  void _deleteFile() {
    try {
      File(data.data ?? '').delete();
    } catch (e) {
      debugPrint("Error in deleting image from cache.");
      debugPrint(e.toString());
    }
  }

  // Open the image.
  void _openFile() {
    if (File(data.data ?? '').existsSync()) {
      OpenFilex.open(data.data ?? '');
    } else {
      // todo: add image fetch failed dialog.
      debugPrint("Image path doesn't exist");
    }
  }
}
