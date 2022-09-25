import 'package:flutter/material.dart';
import 'package:re_vision/base_widgets/base_alert_dialog.dart';
import 'package:re_vision/base_widgets/base_depth_form_field.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';

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
  const _AddAttachment({Key? key}) : super(key: key);

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

class _AttachTypeContainer extends StatelessWidget {
  const _AttachTypeContainer({Key? key}) : super(key: key);

  static final List<AttachmentTypeDm> _attachmentTypes = [
    AttachmentTypeDm(title: StringConstants.article, icon: IconConstants.article),
    AttachmentTypeDm(title: StringConstants.image, icon: IconConstants.image),
    AttachmentTypeDm(title: StringConstants.pdf, icon: IconConstants.pdf),
    AttachmentTypeDm(title: StringConstants.video, icon: IconConstants.video),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      width: 200,
      child: ListView.builder(
        itemCount: _attachmentTypes.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: _attachmentTypes[index].icon,
            title: BaseText(_attachmentTypes[index].title),
          );
        },
      ),
    );
  }
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
            child: GridView.builder(
              gridDelegate: _gridDelegate,
              itemCount: 6,
              itemBuilder: (context, state) {
                return const _AddAttachment();
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

  final SliverGridDelegate _gridDelegate =
      const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    mainAxisSpacing: 8.0,
    crossAxisSpacing: 8.0,
    childAspectRatio: 1,
  );
}
