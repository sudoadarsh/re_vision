import 'dart:io';

import 'package:favicon/favicon.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:re_vision/base_widgets/base_alert_dialog.dart';
import 'package:re_vision/base_widgets/base_depth_form_field.dart';
import 'package:re_vision/base_widgets/base_expanded_section.dart';
import 'package:re_vision/base_widgets/base_image_builder.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/double_extensions.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/models/attachment_data_dm.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../base_widgets/base_underline_field.dart';
import '../../models/attachment_dm.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../state_management/attachment/attachment_cubit.dart';

// 1. The app bar.
class _AppBar extends StatefulWidget with PreferredSizeWidget {
  const _AppBar({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<_AppBar> createState() => _AppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class _AppBarState extends State<_AppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorConstants.button,
      title: BaseText(widget.title),
    );
  }
}

// 2. The Topic text field.
class _TopicField extends StatelessWidget {
  const _TopicField({Key? key, required this.topicController})
      : super(key: key);

  final TextEditingController topicController;

  @override
  Widget build(BuildContext context) {
    return BaseTextFormFieldWithDepth(
      controller: topicController,
      labelText: StringConstants.topicLabel,
    );
  }
}

// 3. Separator widget.
class _Separator extends StatelessWidget {
  const _Separator({Key? key, required this.title}) : super(key: key);

  final String title;

  static const Widget _divider =
      Expanded(child: Divider(thickness: 1, indent: 10.0, endIndent: 10.0));

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _divider,
        BaseText(title),
        _divider,
      ],
    );
  }
}

// 4. To add attachments.
class _Attachments extends StatefulWidget {
  const _Attachments({
    Key? key,
    required this.title,
    required this.leadingIcon,
    required this.expandedView,
  }) : super(key: key);

  final Widget leadingIcon;
  final String title;

  final Widget expandedView;

  @override
  State<_Attachments> createState() => _AttachmentsState();
}

class _AttachmentsState extends State<_Attachments> {
  bool _expand = false;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, sst) {
      return Card(
        child: Column(
          children: [
            // 1. Disabling the splash.
            Theme(
              data: ThemeData(splashColor: Colors.transparent),
              child: ListTile(
                onTap: () => sst(() {
                  _expand = !_expand;
                }),
                leading: widget.leadingIcon,
                title: BaseText(widget.title),
                trailing:
                    !_expand ? IconConstants.expand : IconConstants.collapse,
              ),
            ),
            BaseExpandedSection(expand: _expand, child: widget.expandedView)
          ],
        ),
      );
    });
  }
}

// 5. The expanded view.
class _ExpandedView extends StatelessWidget {
  const _ExpandedView({Key? key, required this.add, required this.type})
      : super(key: key);

  final VoidCallback add;
  final int type;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BlocBuilder<AttachmentCubit, AttachmentState>(
            builder: (context, state) {
          List<AttachmentDataDm> receivedData =
              state.data.where((element) => element.type == type).toList();
          return Column(
            children: receivedData.map((e) => _getTile(e)).toList(),
          );
        }),
        IconButton(
          onPressed: add,
          icon: IconConstants.add,
        ).center(),
      ],
    );
  }

  //----------------------To get the correct tile-------------------------------
  Widget _getTile(AttachmentDataDm e) {
    if (type == 0) {
      return _ArticleTile(data: e);
    } else {
      return _ImageTile(data: e);
    }
  }
}

class TopicPage extends StatefulWidget {
  const TopicPage({Key? key}) : super(key: key);

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  // 1. Controller for the topic field.
  late final TextEditingController _topicController;

  // 2. The list of Attachment types.
  late final List<AttachmentDm> _list;

  @override
  void initState() {
    _topicController = TextEditingController();

    _list = [
      AttachmentDm(
          title: StringConstants.article,
          leadingIcon: IconConstants.article,
          expandedView: _articleExpanded()),
      AttachmentDm(
          title: StringConstants.image,
          leadingIcon: IconConstants.image,
          expandedView: _imageExpanded()),
      AttachmentDm(
          title: StringConstants.pdf,
          leadingIcon: IconConstants.pdf,
          expandedView: SizeConstants.none),
      AttachmentDm(
          title: StringConstants.video,
          leadingIcon: IconConstants.video,
          expandedView: SizeConstants.none),
    ];

    super.initState();
  }

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  // 3. Expanded View for article.
  Widget _articleExpanded() {
    return _ExpandedView(
      add: () {
        _pasteLink();
      },
      type: 0,
    );
  }

  // 4. Expand View for image.
  Widget _imageExpanded() {
    return _ExpandedView(
      add: () {
        _pickImage();
      },
      type: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _AppBar(title: "Add Topic"),
      body: Column(
        children: [
          _TopicField(topicController: _topicController),
          SizeConstants.spaceVertical20,
          const _Separator(title: StringConstants.addAttachment),
          SizeConstants.spaceVertical20,
          Expanded(
            child: ListView.separated(
              itemCount: _list.length,
              itemBuilder: (context, index) {
                return _Attachments(
                  title: _list[index].title,
                  leadingIcon: _list[index].leadingIcon,
                  expandedView: _list[index].expandedView,
                );
              },
              separatorBuilder: (context, index) {
                return const _Separator(title: StringConstants.separator);
              },
            ),
          ),
        ],
      ).paddingDefault(),
    );
  }

  // -------------------------------Functions-----------------------------------

  // 3.1 Dialog box to add links of articles.
  Future _pasteLink() async {
    return await showDialog(
      context: context,
      builder: (context) => const BaseAlertDialog(
        title: StringConstants.saveArticles,
        customContent: SizedBox(width: double.maxFinite, child: _PasteLink()),
        contentPadding: EdgeInsets.only(left: 24.0),
        actionsPadding: SizeConstants.zeroPadding,
        actions: [],
      ),
    );
  }

  // 4.1 File picker to image when the user wants to select an image.
  // todo: add info plist permissions.
  Future _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ["jpg", "jpeg", "jfif", "pjpeg", "pjp", "png"],
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();

      List<AttachmentDataDm> data = files
          .map((e) =>
              AttachmentDataDm(data: e.path, type: AttachmentType.image.value))
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

// 3.1.1 Paste link.
class _PasteLink extends StatefulWidget {
  const _PasteLink({Key? key}) : super(key: key);

  @override
  State<_PasteLink> createState() => _PasteLinkState();
}

class _PasteLinkState extends State<_PasteLink> {
  late List<BaseUnderlineField> _fields;
  late List<TextEditingController> _controller;

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
                          icon: IconConstants.delete,
                        ),
                ],
              );
            },
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
          icon: IconConstants.add,
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
                StringConstants.cancel,
                color: ColorConstants.secondary,
              ),
            ),
            // Save the added links.
            TextButton(
              onPressed: _saveData,
              child: const BaseText(
                StringConstants.save,
                color: ColorConstants.primary,
              ),
            ),
          ],
        ).alignRight(),
      ],
    );
  }

  BaseUnderlineField _field(TextEditingController controller) {
    return BaseUnderlineField(
      hintText: StringConstants.pasteTheLinkHere,
      controller: controller,
    );
  }

  // --------------------------------Functions----------------------------------
  void _saveData() {
    List<AttachmentDataDm> data = _controller
        .where((element) => element.text.isNotEmpty)
        .map((e) =>
            AttachmentDataDm(type: AttachmentType.article.value, data: e.text))
        .toList();
    for (AttachmentDataDm element in data) {
      context.read<AttachmentCubit>().addAttachment(element);
    }
    Navigator.of(context).pop();
  }
}

// 5.1 For Type Article.
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
                error: IconConstants.link,
                height: 20,
                width: 20,
              ).center();
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const CupertinoActivityIndicator();
            }
            return IconConstants.link;
          },
        ),
      ),
      title: BaseText(getWebsiteName()),
      subtitle: const BaseText(
        StringConstants.tapToOpenWeb,
        fontWeight: FontWeight.w300,
        fontSize: 12,
      ),
      trailing: IconButton(
        onPressed: () {
          context.read<AttachmentCubit>().removeAttachment(data);
        },
        icon: IconConstants.delete,
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

// For type Image.
class _ImageTile extends StatelessWidget {
  const _ImageTile({Key? key, required this.data}) : super(key: key);

  final AttachmentDataDm data;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconConstants.image,
      title: BaseText(_getImageName()),
      subtitle: const BaseText(
        StringConstants.tapToOpenImage,
        fontWeight: FontWeight.w300,
        fontSize: 12,
      ),
      trailing: IconButton(
        icon: IconConstants.delete,
        onPressed: () {
          context.read<AttachmentCubit>().removeAttachment(data);
          _deleteImage();
        },
      ),
      onTap: () {
        _openImage();
      },
    );
  }

  // To get the image name.
  String _getImageName() {
    return data.data?.split('/').last ?? '';
  }

  // Deleting the image from cache.
  void _deleteImage() {
    try {
      File(data.data ?? '').delete();
    } catch (e) {
      debugPrint("Error in deleting image from cache.");
      debugPrint(e.toString());
    }
  }

  // Open the image.
  void _openImage() {
    if (File(data.data ?? '').existsSync()) {
      OpenFilex.open(data.data ?? '');
    } else {
      // todo: add image fetch failed dialog.
      debugPrint("Image path doesn't exist");
    }
  }
}
