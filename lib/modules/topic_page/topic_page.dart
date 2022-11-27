import 'dart:convert';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:favicon/favicon.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:open_filex/open_filex.dart';
import 'package:re_vision/base_widgets/base_separator.dart';
import 'package:re_vision/base_widgets/base_skeleton_dialog.dart';
import 'package:re_vision/base_widgets/base_depth_form_field.dart';
import 'package:re_vision/base_widgets/base_expanded_section.dart';
import 'package:re_vision/base_widgets/base_image_builder.dart';
import 'package:re_vision/base_widgets/base_snackbar.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/decoration_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/double_extensions.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/models/attachment_data_dm.dart';
import 'package:re_vision/models/topic_dm.dart';
import 'package:re_vision/state_management/save/save_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../base_sqlite/sqlite_helper.dart';
import '../../base_widgets/base_elevated_button.dart';
import '../../base_widgets/base_underline_field.dart';
import '../../models/attachment_dm.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../state_management/attachment/attachment_cubit.dart';

// 1. The app bar.
class _AppBar extends StatefulWidget with PreferredSizeWidget {
  const _AppBar(
      {Key? key,
      required this.title,
      required this.saveCubit,
      required this.onSaveButtonTap})
      : super(key: key);

  final String title;
  final SaveCubit saveCubit;
  final VoidCallback onSaveButtonTap;

  @override
  State<_AppBar> createState() => _AppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class _AppBarState extends State<_AppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorC.button,
      title: BaseText(widget.title),
      actions: [
        TextButton(
          onPressed: widget.onSaveButtonTap,
          child: BlocBuilder<SaveCubit, SaveState>(
            bloc: widget.saveCubit,
            builder: (context, state) {
              return BaseText(StringC.save,
                  color: state.isSaved ? ColorC.primary : null);
            },
          ),
        ),
      ],
    );
  }
}

// 2. The Topic text field.
class _TopicField extends StatelessWidget {
  const _TopicField({
    Key? key,
    required this.topicController,
    required this.focusNode,
  }) : super(key: key);

  final TextEditingController topicController;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BaseTextFormFieldWithDepth(
        focusNode: focusNode,
        controller: topicController,
        labelText: StringC.topicLabel,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return StringC.pleaseEnterATopic;
          }
          return null;
        });
  }
}

// 3. Separator widget. (moved to base class).

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
                trailing: !_expand ? IconC.expand : IconC.collapse,
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
          icon: IconC.add,
        ).center(),
      ],
    );
  }

  //----------------------To get the correct tile-------------------------------
  Widget _getTile(AttachmentDataDm e) {
    if (type == 0) {
      return _ArticleTile(data: e);
    } else {
      return _CommonTile(data: e);
    }
  }
}

/// The note editor from package flutter_quill.
class _NoteEditor extends StatefulWidget {
  const _NoteEditor({Key? key, required this.qc}) : super(key: key);

  final QuillController qc;

  @override
  State<_NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<_NoteEditor> {
  // The quill controller.
  QuillController get _qc => widget.qc;

  // Focus node for the editor.
  late final FocusNode _fNode;

  @override
  void initState() {
    super.initState();
    _fNode = FocusNode();

    // print(_qc.document.toPlainText());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: DecorC.roundedRectangleBorder,
      child: QuillEditor(
        onTapUp: _onTapUp,
        controller: _qc,
        scrollController: ScrollController(),
        scrollable: true,
        autoFocus: false,
        readOnly: true,
        placeholder: 'Add Note',
        enableSelectionToolbar: isMobile(),
        expands: false,
        padding: const EdgeInsets.all(8.0), focusNode: FocusNode(),
      ),
    );
  }

  bool _onTapUp(TapUpDetails details, TextPosition Function(Offset) offset) {
    // Open the action sheet to add or edit notes.
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: DecorC.roundedRectangleBorderTop,
        builder: (_) => SafeArea(
          child: Column(
            children: [
              QuillToolbar.basic(controller: _qc),
              SizedBox(
                height: 500,
                child: QuillEditor(
                  controller: _qc,
                  scrollController: ScrollController(),
                  scrollable: true,
                  autoFocus: false,
                  readOnly: false,
                  placeholder: 'Add Note',
                  enableSelectionToolbar: isMobile(),
                  expands: true,
                  padding: const EdgeInsets.all(8.0), focusNode: _fNode,
                ),
              ),
            ],
          ),
        )
    );
    return true;
  }
}

/// Enum to control the current tab.
enum _TopicEnum { attachment, notes }

class TopicPage extends StatefulWidget {
  const TopicPage({
    Key? key,
    required this.selectedDay,
    this.topicDm,
  }) : super(key: key);

  final DateTime selectedDay;
  final TopicDm? topicDm;

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  // The save cubit.
  late final SaveCubit _saveCubit;

  // 1. Controller for the topic field.
  late final TextEditingController _topicController;

  // The quill controller.
  late final QuillController _qc;

  // 2. The list of Attachment types.
  late final List<AttachmentDm> _list;

  // The current tab.
  _TopicEnum _currentTab = _TopicEnum.notes;

  @override
  void initState() {
    _topicController = TextEditingController();

    _setInitialData();

    _saveCubit = SaveCubit();

    _list = [
      AttachmentDm(
          title: StringC.article,
          leadingIcon: IconC.article,
          expandedView: _articleExpanded()),
      AttachmentDm(
          title: StringC.image,
          leadingIcon: IconC.image,
          expandedView: _imageExpanded()),
      AttachmentDm(
          title: StringC.pdf,
          leadingIcon: IconC.pdf,
          expandedView: _pdfExpanded()),
      AttachmentDm(
          title: StringC.video,
          leadingIcon: IconC.video,
          expandedView: _videoExpanded()),
    ];

    super.initState();
  }

  // For when this page is navigated through by tapping a topic card.
  void _setInitialData() {
    context.read<AttachmentCubit>().clear();

    if (widget.topicDm != null) {
      // todo: add try and catch block.
      // Setting the topic and the attachments.
      _topicController.text = widget.topicDm?.topic ?? '';
      List decodedAttachments = jsonDecode(widget.topicDm?.attachments ?? '');
      List<AttachmentDataDm> attachmentData =
          decodedAttachments.map((e) => AttachmentDataDm.fromJson(e)).toList();
      for (var element in attachmentData) {
        context.read<AttachmentCubit>().addAttachment(element);
      }

      // Setting up the notes.
      List<dynamic> quillData = jsonDecode(widget.topicDm?.notes ?? '');
      _qc = QuillController(
        document: Document.fromJson(quillData),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      _qc = QuillController.basic();
    }
  }

  @override
  void dispose() {
    _topicController.dispose();
    _qc.dispose();
    _saveCubit.close();
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
        _pickFile(
          allowedExtensions: ["jpg", "jpeg", "jfif", "pjpeg", "pjp", "png"],
          fileType: AttachmentType.image.value,
        );
      },
      type: AttachmentType.image.value,
    );
  }

  // 5. Expand View for pdf.
  Widget _pdfExpanded() {
    return _ExpandedView(
      add: () {
        _pickFile(
          allowedExtensions: ["pdf", "xlsx", "docx", "pptx"],
          fileType: AttachmentType.pdf.value,
        );
      },
      type: AttachmentType.pdf.value,
    );
  }

  // 6. Expand view for videos.
  Widget _videoExpanded() {
    return _ExpandedView(
      add: () {
        _pickFile(
          allowedExtensions: ["mp4", "mov", "wmv", "avi"],
          fileType: AttachmentType.video.value,
        );
      },
      type: AttachmentType.video.value,
    );
  }

  // The form key.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: _AppBar(
          title:
              widget.topicDm == null ? StringC.addTopic : StringC.updateTopic,
          saveCubit: _saveCubit,
          onSaveButtonTap: () {
            if (_formKey.currentState?.validate() ?? false) {
              _saveToLocalDatabase();
            }
          },
        ),
        body: GestureDetector(
          onTap: () {
            _focusNode.unfocus();
          },
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: _TopicField(
                    topicController: _topicController, focusNode: _focusNode),
              ),
              SizeC.spaceVertical20,
              Row(
                children: [
                  Expanded(
                    child: BaseElevatedButton(
                      size: const Size.fromHeight(40.0),
                      backgroundColor: _currentTab == _TopicEnum.attachment
                          ? null
                          : ColorC.primary,
                      onPressed: () {
                        _currentTab = _TopicEnum.notes;
                        setState(() {});
                      },
                      child: BaseText(
                        StringC.note,
                        color: _currentTab == _TopicEnum.attachment
                            ? null
                            : Colors.white,
                      ),
                    ),
                  ),
                  SizeC.spaceHorizontal5,
                  Expanded(
                    child: BaseElevatedButton(
                      size: const Size.fromHeight(40.0),
                      backgroundColor: _currentTab == _TopicEnum.attachment
                          ? ColorC.primary
                          : null,
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        _currentTab = _TopicEnum.attachment;
                        setState(() {});
                      },
                      child: BaseText(
                        StringC.addAttachment,
                        color: _currentTab == _TopicEnum.attachment
                            ? Colors.white
                            : null,
                      ),
                    ),
                  ),
                ],
              ).paddingHorizontal8(),
              SizeC.spaceVertical20,
              _currentTab == _TopicEnum.attachment
                  ? Expanded(
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
                          return const BaseSeparator(title: StringC.separator);
                        },
                      ),
                    )
                  : _NoteEditor(qc: _qc),
            ],
          ).paddingDefault(),
        ),
      ),
    );
  }

  // -------------------------------Functions-----------------------------------

  // 3.1 Dialog box to add links of articles.
  Future _pasteLink() async {
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

  // 4.1 File picker to pick image when the user wants to select an image.
  // todo: add info plist permissions.
  Future _pickFile({
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

  // To alert the user before leaving the screen.
  Future<bool> _onWillPop() async {
    return _saveCubit.state.isSaved
        ? true
        : (await showDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: const BaseText (StringC.areYouSureExit),
                content: const BaseText(StringC.consequences),
                actions: [
                  CupertinoDialogAction(
                    child: const BaseText(StringC.save),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _saveToLocalDatabase();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  CupertinoDialogAction(
                    child: const BaseText(StringC.discard),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              ),
            )) ??
            false;
  }

  void _saveToLocalDatabase() async {
    // Mapping the attachments.
    List<AttachmentDataDm> attachments =
        context.read<AttachmentCubit>().state.data;
    List<Map<String, dynamic>> jsonData =
        attachments.map((e) => e.toJson()).toList();

    // Mapping the notes.
    List<dynamic> jsonQuill = _qc.document.toDelta().toJson();

    if (widget.topicDm == null) {
      // todo: add condition for empty topic field.
      // Creating the topic data.
      final TopicDm data = TopicDm(
        id: const Uuid().v1(),
        topic: _topicController.text,
        attachments: jsonEncode(jsonData),
        notes: jsonEncode(jsonQuill),
        createdAt: widget.selectedDay.toString().replaceAll('Z', ''),
        scheduledTo: widget.selectedDay.toString().replaceAll('Z', ''),
        iteration: 1,
        isOnline: 0
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
          topic: _topicController.text,
          attachments: jsonEncode(jsonData),
          notes: jsonEncode(jsonQuill));

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

// 3.1.1 Paste link.
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

// For type Image.
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

// Screen arguments.
class TopicPageArguments {
  final DateTime selectedDay;
  final TopicDm? topicDm;

  TopicPageArguments({required this.selectedDay, this.topicDm});
}
