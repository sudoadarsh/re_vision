// ignore_for_file: depend_on_referenced_packages

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
import 'package:re_vision/modules/attachment/attachment_page.dart';
import 'package:re_vision/modules/labels/labels_page.dart';
import 'package:re_vision/modules/topic_page/topic_page_view.dart';
import 'package:re_vision/state_management/attachment/attachment_cubit.dart';

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

  /// Boolean to hide the quill toolbar.
  late bool _hideTB = true;

  @override
  void initState() {
    super.initState();

    _titleC = TextEditingController();
    _notesC = QuillController.basic();

    _notesFN = FocusNode();

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
  }

  @override
  Widget build(BuildContext context) {
    /// Keyboard is visible.
    bool keyVisible = MediaQuery.of(context).viewInsets.bottom > 0.0;

    return Scaffold(
      // The app bar.
      appBar: title(_titleC),

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
                    child: const Chip(
                      avatar: CircleAvatar(
                        backgroundColor: Colors.white,
                        foregroundColor: ColorC.primary,
                        child: IconC.options,
                      ),
                      label: BaseText(
                        StringC.addLabels,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  SizeC.spaceHorizontal5,
                  BlocBuilder<AttachmentCubit, AttachmentState>(
                    builder: (context, state) {
                      List<AttachmentDataDm> receivedData = state.data;

                      if (receivedData.isEmpty) return SizeC.none;

                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            RouteC.attachments,
                            arguments:
                                AttachmentPageArguments(data: receivedData),
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
              ),
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

      // The floating action button with multiple selection options.
      floatingActionButton: Visibility(
        visible: !keyVisible,
        child: expandableFab(),
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
        content: const LabelsPage(),
        actions: [
          CupertinoDialogAction(
            child: const BaseText(StringC.cancel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: const BaseText(StringC.save),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
