import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/modules/topic_page/topic_page_view.dart';

import '../../models/topic_dm.dart';

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

  @override
  void initState() {
    super.initState();

    _titleC = TextEditingController();
    _notesC = QuillController.basic();

    _notesFN = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The app bar.
      appBar: title(_titleC),

      // The body.
      body: Stack(
        children: [
          QuillEditor(
            controller: _notesC,
            scrollController: ScrollController(),
            scrollable: true,
            autoFocus: true,
            readOnly: false,
            expands: true,
            padding: const EdgeInsets.all(8.0),
            focusNode: _notesFN,
          ),
          MediaQuery.of(context).viewInsets.bottom > 0.0
              ? Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  left: 0.0,
                  child: QuillToolbar.basic(controller: _notesC),
                )
              : SizeC.none
        ],
      ),
    );
  }
}
