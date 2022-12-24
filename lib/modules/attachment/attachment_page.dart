import 'dart:io';

import 'package:favicon/favicon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../base_widgets/base_image_builder.dart';
import '../../base_widgets/base_text.dart';
import '../../constants/icon_constants.dart';
import '../../constants/string_constants.dart';
import '../../models/attachment_data_dm.dart';
import '../../state_management/attachment/attachment_cubit.dart';

/// Attachment page arguments.
class AttachmentPageArguments {
  final List<AttachmentDataDm> data;

  AttachmentPageArguments({required this.data});
}

class AttachmentPage extends StatefulWidget {
  const AttachmentPage({Key? key, required this.data}) : super(key: key);

  final List<AttachmentDataDm> data;

  @override
  State<AttachmentPage> createState() => _AttachmentPageState();
}

class _AttachmentPageState extends State<AttachmentPage> {
  /// The list of attachments added.
  late List<AttachmentDataDm> data;

  @override
  void initState() {
    super.initState();

    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
                itemCount: data.length, itemBuilder: (context, i) {
                  return _getTile(data[i]);
            }),
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


