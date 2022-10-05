import 'package:flutter/material.dart';
import 'package:re_vision/base_widgets/base_depth_form_field.dart';
import 'package:re_vision/base_widgets/base_expanded_section.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';

import '../../models/attachment_dm.dart';

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
      return Column(
        children: [
          Card(
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
      );
    });
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

  @override
  void initState() {
    _topicController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  // 2. The list of Attachment types.
  final List<AttachmentDm> _list = [
    AttachmentDm(title: StringConstants.article, leadingIcon: IconConstants.article, expandedView: SizeConstants.none),
    AttachmentDm(title: StringConstants.image, leadingIcon: IconConstants.image, expandedView: SizeConstants.none),
    AttachmentDm(title: StringConstants.pdf, leadingIcon: IconConstants.pdf, expandedView: SizeConstants.none),
    AttachmentDm(title: StringConstants.video, leadingIcon: IconConstants.video, expandedView: SizeConstants.none),
  ];

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
            child: ListView.builder(
              itemCount: _list.length,
              itemBuilder: (context, index) {
                print (_list[index].title);
                return _Attachments(
                  title: _list[index].title,
                  leadingIcon: _list[index].leadingIcon,
                  expandedView: const BaseText('none'),
                );
              },
            ),
          ),
        ],
      ).paddingDefault(),
    );
  }
}
