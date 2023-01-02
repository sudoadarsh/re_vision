// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/modules/labels/labels_page.dart';
import 'package:re_vision/modules/topic_page/topic_page_view.dart';
import 'package:re_vision/state_management/attachment/attachment_cubit.dart';
import 'package:uuid/uuid.dart';
import '../../base_sqlite/sqlite_helper.dart';
import '../../base_widgets/base_snackbar.dart';
import '../../models/attachment_data_dm.dart';
import '../../models/topic_dm.dart';
import '../../routes/route_constants.dart';
import 'package:tuple/tuple.dart';

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

class _TopicPageV1State extends State<TopicPageV1> with TopicPageView {
  /// The text editing controllers.
  ///
  late final TextEditingController _titleC;
  late final QuillController _notesC;

  /// The focus node.
  late final FocusNode _notesFN;
  late final FocusNode _titleFN;

  /// Boolean to hide the quill toolbar.
  late bool _hideTB = true;

  /// To store the selected Labels.
  late List _selectedLabels;

  @override
  void initState() {
    super.initState();

    _selectedLabels = [];

    _titleC = TextEditingController();
    // _notesC = QuillController.basic();

    _notesFN = FocusNode();
    _titleFN = FocusNode();

    _notesFN.addListener(() {
      if (_hideTB && !_notesFN.hasFocus) {
        _hideTB = false;
        setState(() {});
        return;
      } else if (!_hideTB && _notesFN.hasFocus) {
        _hideTB = true;
        setState(() {});
        return;
      }
    });

    _titleFN.addListener(() {
      if (_hideTB && _titleFN.hasFocus) {
        _hideTB = false;
        setState(() {});
        return;
      } else if (!_hideTB && !_titleFN.hasFocus) {
        _hideTB = true;
        setState(() {});
        return;
      }
    });

    _setInitialData();
  }

  @override
  Widget build(BuildContext context) {
    /// Keyboard is visible.
    bool keyVisible = MediaQuery.of(context).viewInsets.bottom > 0.0;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        // The app bar.
        appBar: title(
          controller: _titleC,
          onSaveTap: _onSaveTap,
          focusNode: _titleFN,
        ),

        // The body.
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // To add labels.
                Row(
                  children: [
                    InkWell(
                      onTap: _showLabelsDialog,
                      child: Chip(
                        avatar: const CircleAvatar(
                          backgroundColor: Colors.white,
                          foregroundColor: ColorC.primary,
                          child: IconC.options,
                        ),
                        label: BaseText(
                          _selectedLabels.isEmpty
                              ? StringC.addLabels
                              : _selectedLabels.first.toString(),
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    SizeC.spaceHorizontal5,
                    BlocBuilder<AttachmentCubit, AttachmentState>(
                      builder: (context, state) {
                        // List<AttachmentDataDm> receivedData = state.data;

                        return InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              RouteC.attachments,
                            );
                          },
                          child: const Chip(
                            avatar: CircleAvatar(
                              backgroundColor: Colors.white,
                              foregroundColor: ColorC.primary,
                              child: IconC.folder,
                            ),
                            label: BaseText(
                              StringC.addAttachment,
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ).paddingOnly(left: 4, right: 4),
                Flexible(
                  child: QuillEditor(
                    placeholder: StringC.addNote,
                    controller: _notesC,
                    scrollController: ScrollController(),
                    scrollable: true,
                    autoFocus: false,
                    readOnly: false,
                    expands: true,
                    padding: const EdgeInsets.all(8.0),
                    focusNode: _notesFN,
                    customStyles: DefaultStyles(
                      placeHolder: DefaultTextBlockStyle(
                        const TextStyle(fontSize: 16, color: Colors.black),
                        const Tuple2<double, double>(8, 8),
                        const Tuple2(3, 3),
                        const BoxDecoration(),
                      ),
                    ),
                  ).paddingOnly(bottom: keyVisible ? 100.0 : 0.0),
                ),
              ],
            ),
            keyVisible && _hideTB
                ? Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    left: 0.0,
                    child: QuillToolbar.basic(
                      controller: _notesC,
                      showFontFamily: false,
                      showFontSize: false,
                      iconTheme: const QuillIconTheme(
                        iconSelectedFillColor: ColorC.primary,
                        iconSelectedColor: ColorC.white,
                      ),
                    ),
                  )
                : SizeC.none
          ],
        ),
      ),
    );
  }

  // ------------------------- Class methods -----------------------------------

  /// Method to show the labels dialog.
  void _showLabelsDialog() async {
    await showDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const BaseText(StringC.appName),
        content: LabelsPage(selectedLabels: _selectedLabels),
        actions: [
          CupertinoDialogAction(
            child: const BaseText(StringC.ok),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  /// Function to perform when the save button is tapped.
  void _onSaveTap() async {
    // Check if the topic name is empty.
    if (_titleC.text.isEmpty) {
      _emptyTopicNameDialog();
      return;
    }

    // Mapping the attachments.
    List<AttachmentDataDm> attachments =
        context.read<AttachmentCubit>().state.data;
    List<Map<String, dynamic>> jsonData =
        attachments.map((e) => e.toJson()).toList();

    // Mapping the notes.
    List<dynamic> jsonQuill = _notesC.document.toDelta().toJson();

    if (widget.topicDm == null) {
      // todo: add condition for empty topic field.
      // Creating the topic data.
      final TopicDm data = TopicDm(
        id: const Uuid().v1(),
        topic: _titleC.text,
        attachments: jsonEncode(jsonData),
        label: _selectedLabels.isNotEmpty ? _selectedLabels.first : null,
        notes: jsonEncode(jsonQuill),
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
          topic: _titleC.text,
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
  }

  /// For when this page is navigated through by tapping a topic card.
  void _setInitialData() {
    context.read<AttachmentCubit>().clear();

    if (widget.topicDm != null) {
      // Setting the topic and the attachments.
      _titleC.text = widget.topicDm?.topic ?? '';
      List decodedAttachments = jsonDecode(widget.topicDm?.attachments ?? '');
      List<AttachmentDataDm> attachmentData =
          decodedAttachments.map((e) => AttachmentDataDm.fromJson(e)).toList();
      for (var element in attachmentData) {
        context.read<AttachmentCubit>().addAttachment(element);
      }

      // Setting up the notes.
      List<dynamic> quillData = jsonDecode(widget.topicDm?.notes ?? '');
      _notesC = QuillController(
        document: Document.fromJson(quillData),
        selection: const TextSelection.collapsed(offset: 0),
      );

      // Setting up the labels.
      _selectedLabels.add(widget.topicDm?.label ?? "[]");
    } else {
      _notesC = QuillController.basic();
    }
  }

  /// Dialog to alert the user about an empty topic name.
  void _emptyTopicNameDialog() async {
    await showDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const BaseText(StringC.appName),
        content: const BaseText(StringC.noTopicNameAdded),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const BaseText(StringC.ok),
          )
        ],
      ),
    );
    // Give focus to title controller.
    _titleFN.requestFocus();
    return;
  }

  // To alert the user before leaving the screen.
  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const BaseText(StringC.areYouSureExit),
            content: const BaseText(StringC.consequences),
            actions: [
              CupertinoDialogAction(
                child: const BaseText(StringC.resume),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              CupertinoDialogAction(
                child: const BaseText(StringC.discard, color: ColorC.delete),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        ) ??
        false;
  }
}
