import 'package:favicon/favicon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_vision/base_widgets/base_alert_dialog.dart';
import 'package:re_vision/base_widgets/base_depth_form_field.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/state_management/attachment_cubit.dart';

import '../../models/attachment_dm.dart';
import '../../models/attachment_type_dm.dart';

class _AppBar {
  static PreferredSizeWidget appBar(String title) {
    return AppBar(
      title: BaseText(title),
      backgroundColor: ColorConstants.button,
    );
  }
}

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

class _Separator extends StatelessWidget {
  const _Separator({Key? key}) : super(key: key);

  static const Widget _divider =
      Expanded(child: Divider(thickness: 1, indent: 10.0, endIndent: 10.0));

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _divider,
        BaseText(StringConstants.addAttachment),
        _divider,
      ],
    );
  }
}

class _AddAttachment extends StatelessWidget {
  const _AddAttachment({Key? key, this.attachmentDm}) : super(key: key);

  final AttachmentDm? attachmentDm;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await showDialog(
          context: context,
          builder: (_) => const BaseAlertDialog(
            title: StringConstants.selectAttachmentType,
            customContent: _AttachTypeContainer(),
            actions: [SizeConstants.none],
          ),
        );
      },
      child: const Card(
        child: IconConstants.add,
      ),
    );
  }
}

class _AttachTypeContainer extends StatefulWidget {
  const _AttachTypeContainer({Key? key}) : super(key: key);

  static final List<AttachmentTypeDm> _attachmentTypes = [
    AttachmentTypeDm(
        title: StringConstants.article, icon: IconConstants.article),
    AttachmentTypeDm(title: StringConstants.image, icon: IconConstants.image),
    AttachmentTypeDm(title: StringConstants.pdf, icon: IconConstants.pdf),
    AttachmentTypeDm(title: StringConstants.video, icon: IconConstants.video),
  ];

  @override
  State<_AttachTypeContainer> createState() => _AttachTypeContainerState();
}

class _AttachTypeContainerState extends State<_AttachTypeContainer> {
  // Key to obtain the value from the link paste field.
  late final TextEditingController _linkPaste;

  // Boolean to control the current visible widget in the dropdown.
  late bool _addAttachment;

  @override
  void initState() {
    _linkPaste = TextEditingController();
    _addAttachment = false;
    super.initState();
  }

  @override
  void dispose() {
    _linkPaste.dispose();
    super.dispose();
  }

  Widget _saveAttachment() {
    return Column(
      children: [
        BaseTextFormFieldWithDepth(
          controller: _linkPaste,
          hintText: StringConstants.pasteTheLinkHere,
          maxLines: 6,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Button to save the link pasted.
            TextButton(
              onPressed: () {
                _addAttachment = !_addAttachment;
                sst();
              },
              child: const BaseText(
                StringConstants.cancel,
                color: ColorConstants.secondary,
              ),
            ),

            // Button to cancel adding a link.
            TextButton(
              onPressed: () {
                if (_linkPaste.text.isNotEmpty) {
                  context.read<AttachmentCubit>().addAttachment(AttachmentDm(
                      type: StringConstants.link, data: _linkPaste.text));
                }
                Navigator.pop(context);
              },
              child: const BaseText(
                StringConstants.save,
                color: ColorConstants.primary,
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      width: 200,
      child: StatefulBuilder(
        builder: (context, set) {
          return _addAttachment
              ? _saveAttachment()
              : ListView.builder(
                  itemCount: _AttachTypeContainer._attachmentTypes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading:
                          _AttachTypeContainer._attachmentTypes[index].icon,
                      onTap: () {
                        set(() {
                          _addAttachment = !_addAttachment;
                        });
                      },
                      title: BaseText(
                        _AttachTypeContainer._attachmentTypes[index].title,
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  void sst() => setState(() {});
}

class TopicPage extends StatefulWidget {
  const TopicPage({Key? key}) : super(key: key);

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  // Controller for the topic entry field.
  late final TextEditingController _topicController;

  @override
  void initState() {
    _topicController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar.appBar('Add topic'),
      body: Column(
        children: [
          _TopicField(topicController: _topicController),
          SizeConstants.spaceVertical20,
          const _Separator(),
          Expanded(
            child: BlocBuilder<AttachmentCubit, AttachmentState>(
              builder: (context, state) {
                return GridView.builder(
                  gridDelegate: _gridDelegate,
                  itemCount: state.attachments.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const _AddAttachment();
                    }
                    return _AddAttachment(
                      attachmentDm: state.attachments[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ).paddingDefault(),
    );
  }

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  // Grid delete for the grid view builder.
  final SliverGridDelegate _gridDelegate =
      const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    mainAxisSpacing: 8.0,
    crossAxisSpacing: 8.0,
    childAspectRatio: 1,
  );

  // Function to get the url of a website.
  Future<String?> getUrlImage(String url) async {
    Favicon? data = await FaviconFinder.getBest(url);
    return data?.url;
  }
}
