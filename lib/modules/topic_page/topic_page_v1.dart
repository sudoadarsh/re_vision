import 'dart:convert';
import 'dart:io';

import 'package:favicon/favicon.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:re_vision/base_widgets/base_depth_form_field.dart';
import 'package:re_vision/constants/decoration_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/extensions/double_extensions.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/utils/app_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../base_sqlite/sqlite_helper.dart';
import '../../base_widgets/base_image_builder.dart';
import '../../base_widgets/base_skeleton_dialog.dart';
import '../../base_widgets/base_snackbar.dart';
import '../../base_widgets/base_text.dart';
import '../../base_widgets/base_underline_field.dart';
import '../../constants/color_constants.dart';
import '../../constants/size_constants.dart';
import '../../constants/string_constants.dart';
import '../../models/attachment_data_dm.dart';
import '../../models/topic_dm.dart';
import '../../state_management/attachment/attachment_cubit.dart';
import '../../state_management/save/save_cubit.dart';

class TopicPageV1 extends StatefulWidget {
  const TopicPageV1({
    Key? key,
    required this.selectedDay,
    this.topicDm,
  }) : super(key: key);

  final DateTime selectedDay;
  final TopicDm? topicDm;

  @override
  State<TopicPageV1> createState() => _TopicPageV1State();
}

class _TopicPageV1State extends State<TopicPageV1> {
  /// The save cubit.
  late final SaveCubit _saveCubit;

  /// Text Editing controller for the topic.
  late final TextEditingController _topicC;

  /// The notes controller.
  late final TextEditingController _noteC;

  /// The list of visible widgets in the body of [TopicPageV1].
  List<Widget> body = [];

  /// The list of attachment options.
  late final List<Widget> _attachmentOptions;

  /// Boolean to check if the heading of attachment is added or not.
  late bool _attachmentTitle;

  @override
  void initState() {
    super.initState();

    _saveCubit = SaveCubit();
    _topicC = TextEditingController();
    _noteC = TextEditingController();

    _attachmentOptions = [
      CircleAvatar(
        child: IconButton(
          onPressed: _pasteLink,
          icon: IconC.article,
        ),
      ),
      CircleAvatar(
        child: IconButton(
          onPressed: () => _pickFile(
            allowedExtensions: ["jpg", "jpeg", "jfif", "pjpeg", "pjp", "png"],
            fileType: AttachmentType.image.value,
          ),
          icon: IconC.image,
        ),
      ),
      CircleAvatar(
        child: IconButton(
          onPressed: () => _pickFile(
            allowedExtensions: ["pdf", "xlsx", "docx", "pptx"],
            fileType: AttachmentType.pdf.value,
          ),
          icon: IconC.pdf,
        ),
      ),
      CircleAvatar(
        child: IconButton(
          onPressed: () => _pickFile(
            allowedExtensions: ["mp4", "mov", "wmv", "avi"],
            fileType: AttachmentType.video.value,
          ),
          icon: IconC.video,
        ),
      ),
    ];

    _attachmentTitle = false;

    _setInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // hint: Use this to avoid the jumping of the widget that floats with the keyboard.
      resizeToAvoidBottomInset: false,

      /// The app bar of the [TopicPageV1]
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: BaseText(
          widget.topicDm == null ? StringC.addTopic : StringC.updateTopic,
        ),
        actions: [
          TextButton(
            onPressed: () {
              // todo: on save button tap.
              _saveToLocalDatabase();
            },
            child: BlocBuilder<SaveCubit, SaveState>(
              bloc: _saveCubit,
              builder: (context, state) {
                return BaseText(
                  StringC.save,
                  color: state.isSaved ? ColorC.primary : null,
                );
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Tapping outside the text field will close the keyboard.
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView.builder(
              itemCount: body.length + 1,
              itemBuilder: (context, i) {
                if (i >= body.length) {
                  return BlocBuilder<AttachmentCubit, AttachmentState>(
                    builder: (context, state) {
                      return Visibility(
                        visible: state.data.isNotEmpty,
                        child: _attachments(),
                      );
                    },
                  );
                }
                return body[i].paddingHorizontal8();
              },
            ),
          ),

          /// The widget that floats with the keyboard.
          Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 0,
            right: 0,
            child: Column(
              children: [
                _topicC.text.isNotEmpty
                    ? SizedBox(
                        height: 60,
                        child: ListView.builder(
                          itemCount: _attachmentOptions.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, i) {
                            return _attachmentOptions[i].paddingDefault();
                          },
                        ),
                      )
                    : SizeC.none,
                _topicC.text.isEmpty
                    ? _topicHeading()
                    : _noteC.text.isEmpty
                        ? _notesHeading()
                        : SizeC.none,
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------- Class methods -----------------------------------

  /// Set the initial data.
  void _setInitialData() {
    context.read<AttachmentCubit>().clear();
    if (widget.topicDm != null) {
      // todo: add try and catch block.
      // Setting the topic.
      _topicC.text = widget.topicDm?.topic ?? '';
      body.add(_topic());
      // Setting the notes.
      body.add(
        const BaseText(
          StringC.note,
          fontSize: 20,
          fontWeight: FontWeight.w300,
        ).paddingHorizontal8(),
      );
      body.add(_notes());
      List decodedAttachments = jsonDecode(widget.topicDm?.attachments ?? '');
      List<AttachmentDataDm> attachmentData =
          decodedAttachments.map((e) => AttachmentDataDm.fromJson(e)).toList();
      for (var element in attachmentData) {
        context.read<AttachmentCubit>().addAttachment(element);
      }

      _attachmentTitle = true;

      // Setting up the notes.
      _noteC.text = widget.topicDm?.notes ?? '';
    }
  }

  /// The topic heading.
  Widget _topicHeading() {
    return BaseTextFormFieldWithDepth(
      controller: _topicC,
      inputFormatters: [UpperCaseTextFormatter()],
      labelText: StringC.topicLabel,
      suffixIcon: IconButton(
        onPressed: () {
          body.add(_topic());
          setState(() {});
        },
        icon: IconC.send,
      ),
    ).paddingDefault();
  }

  Widget _topic() {
    return TextFormFieldWithoutBorder(
      minLines: 1,
      maxLines: 3,
      style: const TextStyle(fontSize: 20),
      controller: _topicC,
      inputFormatters: [UpperCaseTextFormatter()],
      suffixIcon: IconButton(
        color: ColorC.link,
        icon: IconC.edit,
        onPressed: () {},
      ),
    ).paddingOnly(left: 6);
  }

  /// The attachment section.
  Widget _attachments() {
    return BlocConsumer<AttachmentCubit, AttachmentState>(
      listener: (context, state) {
        if (!_attachmentTitle && state.data.isNotEmpty) {
          setState(() {
            _attachmentTitle = true;
          });
        } else if (_attachmentTitle && state.data.isEmpty) {
          setState(() {
            _attachmentTitle = false;
          });
        }
      },
      builder: (context, state) {
        List<AttachmentDataDm> receivedData = state.data;
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BaseText(
                  StringC.addAttachment,
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                ).paddingHorizontal8(),
                Card(
                  shape: DecorC.roundedRectangleBorder,
                  child: BaseText(receivedData.length.toString())
                      .paddingOnly(left: 16, right: 16, top: 8, bottom: 8),
                ),
              ],
            ),
            Card(
              child: SizedBox(
                width: double.infinity,
                height: AppConfig.height(context) * 0.3,
                child: ListView.builder(
                  itemCount: receivedData.length,
                  itemBuilder: (context, i) {
                    return _getTile(receivedData[i]);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// The notes.
  Widget _notesHeading() {
    return BaseTextFormFieldWithDepth(
      controller: _noteC,
      suffixIcon: IconButton(
        onPressed: () {
          body.add(
            const BaseText(
              StringC.note,
              fontSize: 20.0,
              fontWeight: FontWeight.w300,
            ).paddingHorizontal8(),
          );
          body.add(_notes());
          setState(() {});
        },
        icon: IconC.send,
      ),
      labelText: StringC.addNote,
    ).paddingDefault();
  }

  Widget _notes() {
    return Card(
      shape: DecorC.roundedRectangleBorder,
      child: TextFormFieldWithoutBorder(
        maxLines: 8,
        controller: _noteC,
      ).paddingDefault(),
    );
  }

  Widget _getTile(AttachmentDataDm e) {
    if (e.type == 0) {
      return _ArticleTile(data: e);
    } else {
      return _CommonTile(data: e);
    }
  }

  /// To paste link for article attachments.
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

  /// Function to save the data locally.
  Future<void> _saveToLocalDatabase() async {
    // Mapping the attachments.
    List<AttachmentDataDm> attachments =
        context.read<AttachmentCubit>().state.data;
    List<Map<String, dynamic>> jsonData =
        attachments.map((e) => e.toJson()).toList();

    if (widget.topicDm == null) {
      // todo: add condition for empty topic field.
      // Creating the topic data.
      final TopicDm data = TopicDm(
        id: const Uuid().v1(),
        topic: _topicC.text,
        attachments: jsonEncode(jsonData),
        notes: _noteC.text,
        createdAt: widget.selectedDay.toString().replaceAll('Z', ''),
        scheduledTo: widget.selectedDay.toString().replaceAll('Z', ''),
        iteration: 1,
        isOnline: 0,
      );

      try {
        await BaseSqlite.insert(
          tableName: StringC.topicTable,
          data: data,
        );
        if (!mounted) return;
        baseSnackBar(context,
            message: StringC.savedSuccessfully, leading: IconC.success);
        Navigator.of(context).pop(true);
      } catch (e) {
        debugPrint(e.toString());
        baseSnackBar(context,
            message: StringC.errorInSaving, leading: IconC.failed);
        Navigator.of(context).pop(true);
      }
    } else {
      // Creating the topic data.
      final TopicDm? data = widget.topicDm?.copyWith(
        topic: _topicC.text,
        attachments: jsonEncode(jsonData),
        notes: _noteC.text,
      );

      // Updating the database.
      try {
        await BaseSqlite.update(
          tableName: StringC.topicTable,
          data: data ?? TopicDm(),
          where: StringC.id,
          whereArgs: data?.id,
        );
        if (!mounted) return;
        baseSnackBar(context,
            message: StringC.savedSuccessfully, leading: IconC.success);
        Navigator.of(context).pop(true);
      } catch (e) {
        debugPrint(e.toString());
        baseSnackBar(context,
            message: StringC.errorInSaving, leading: IconC.failed);
        Navigator.of(context).pop(true);
      }
    }

    // Clearing the cubit.
    if (!mounted) return;
    context.read<AttachmentCubit>().clear();
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
      // todo: add file fetch failed dialog.
      debugPrint("File path doesn't exist");
    }
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

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class TextFormFieldWithoutBorder extends StatelessWidget {
  const TextFormFieldWithoutBorder({
    Key? key,
    required this.controller,
    this.inputFormatters,
    this.suffixIcon,
    this.maxLines,
    this.minLines,
    this.style,
  }) : super(key: key);

  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? minLines;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: style,
      minLines: minLines,
      maxLines: maxLines ?? 1,
      inputFormatters: inputFormatters,
      controller: controller,
      decoration:
          InputDecoration(border: InputBorder.none, suffixIcon: suffixIcon),
    );
  }
}
