import 'package:flutter/material.dart';
import 'package:re_vision/base_widgets/base_alert_dialog.dart';
import 'package:re_vision/base_widgets/base_depth_form_field.dart';
import 'package:re_vision/base_widgets/base_expanded_section.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/double_extensions.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/models/attachment_data_dm.dart';

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
  const _ExpandedView({Key? key, required this.add}) : super(key: key);

  final VoidCallback add;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ListView(),
        BlocBuilder<AttachmentCubit, AttachmentState>(builder: (context, state) {
          print (state.data);
          return SizeConstants.none;
        }),
        IconButton(
          onPressed: add,
          icon: IconConstants.add,
        ).center(),
      ],
    );
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
          expandedView: SizeConstants.none),
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
    return _ExpandedView(add: () {
      _pasteLink();
    });
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
        customContent: _PasteLink(),
        contentPadding: EdgeInsets.only(left: 24.0),
        actionsPadding: SizeConstants.zeroPadding,
        actions: [],
      ),
    );
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
                  index == 0 ? 50.0.separation(false) : IconButton(
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
    List<AttachmentDataDm> data = _controller.where((element) => element.text.isNotEmpty).map((e) =>
        AttachmentDataDm(type: AttachmentType.article.value, data: e.text)).toList();
    for (AttachmentDataDm element in data) {
      context.read<AttachmentCubit>().addAttachment(element);
    }
    Navigator.of(context).pop();
  }
}
