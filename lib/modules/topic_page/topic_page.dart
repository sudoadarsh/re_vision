import 'package:favicon/favicon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_vision/base_widgets/base_depth_form_field.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/decoration_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/state_management/attachment/attachment_cubit.dart';

import '../../base_widgets/base_bottom_modal_sheet.dart';
import '../../models/attachment_dm.dart';
import '../add_attachment_page/add_attachment_page.dart';

class _AppBar extends StatelessWidget with PreferredSizeWidget {
  const _AppBar({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: BaseText(title),
      backgroundColor: ColorConstants.button,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
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

class TopicPage extends StatefulWidget {
  const TopicPage({Key? key}) : super(key: key);

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  // Controller for the topic entry field.
  late final TextEditingController _topicController;

  // List to store the grid cards of added attachments.
  List<AttachmentDm> _attachmentCards = [];

  @override
  void initState() {
    _topicController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _AppBar(title: 'Add topic'),
      body: Column(
        children: [
          _TopicField(topicController: _topicController),
          SizeConstants.spaceVertical20,
          const _Separator(),
          SizeConstants.spaceVertical20,
          Expanded(
            child: BlocBuilder<AttachmentCubit, AttachmentState>(
              builder: (context, state) {
                _attachmentCards = state.attachments + [AttachmentDm()];

                // The grid of attachments.
                return GridView.builder(
                  gridDelegate: _gridDelegate,
                  itemCount: _attachmentCards.length,
                  itemBuilder: (context, index) {
                    String data = _attachmentCards[index].data ?? '';
                    return InkWell(
                      onTap: () async {
                        data.isNotEmpty
                            ? null
                            : WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          _addAttachmentSheet();
                        });
                      },
                      child: const Card(
                        child: IconConstants.add,
                      ),
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

  // Function to open to the bottom modal screen to select the attachment
  // type.
  Future _addAttachmentSheet() async =>
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: DecorationConstants.roundedRectangleBorderTop,
        builder: (_) =>
            BlocProvider(
              create: (context) => AttachmentCubit(),
              child: BaseBottomModalSheet(
                context: context,
                child: const AddAttachmentPage(),
              ),
            ),
      );
}
