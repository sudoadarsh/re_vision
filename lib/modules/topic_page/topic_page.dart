import 'package:favicon/favicon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_vision/base_widgets/base_depth_form_field.dart';
import 'package:re_vision/base_widgets/base_image_builder.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/decoration_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/state_management/save_or_delete_attachment/save_delete_cubit.dart';

import '../../base_widgets/base_bottom_modal_sheet.dart';
import '../../models/attachment_dm.dart';
import '../add_attachment_page/add_attachment_page.dart';

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
  List<AttachmentDm> attachmentCards = [AttachmentDm()];

  // The current index.
  int _index = 0;

  @override
  void initState() {
    _topicController = TextEditingController();
    super.initState();
  }

  // The app bar.
  PreferredSizeWidget _appBar(String title) {
    return AppBar(
      title: BaseText(title),
      backgroundColor: ColorConstants.button,
      actions: [
        BlocBuilder<SaveDeleteCubit, SaveDeleteState>(
          builder: (context, state) {
            if (state.isLongPressed) {
              return IconButton(
                onPressed: () {
                  _deleteAttachment(_index);
                  context.read<SaveDeleteCubit>().changeState();
                },
                icon: IconConstants.delete,
              );
            }
            return IconButton(onPressed: () {}, icon: IconConstants.save);
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar('Add topic'),
      body: Column(
        children: [
          _TopicField(topicController: _topicController),
          SizeConstants.spaceVertical20,
          const _Separator(),
          SizeConstants.spaceVertical20,
          Expanded(
            child: GridView.builder(
              gridDelegate: _gridDelegate,
              itemCount: attachmentCards.length,
              itemBuilder: (context, index) {
                String data = attachmentCards[index].data ?? '';
                return InkWell(
                  // Delete an attachment.
                  onLongPress: () {
                    _index = index;
                    setState(() {});
                    context.read<SaveDeleteCubit>().changeState();
                  },
                  // Open the bottom sheet.
                  onTap: () async {
                    data.isNotEmpty
                        ? null
                        : WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                            _addAttachmentSheet();
                          });
                  },
                  child: Card(
                    child: data.isEmpty
                        ? IconConstants.add
                        : _getAppropriateCard(attachmentCards[index]).center(),
                  ),
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

  // Function to expose the correct card according to the type of attachment.
  Widget _getAppropriateCard(AttachmentDm attachment) {
    if (attachment.isArticle) {
      return FutureBuilder(
        future: getUrlImage(attachment.data ?? ''),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return IconConstants.noFavIcon;
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CupertinoActivityIndicator();
          } else if (snapshot.hasData) {
            return BaseImageBuilder(
              url: snapshot.data ?? '',
              height: 40,
              width: 40,
              error: IconConstants.noFavIcon,
            );
          }
          return SizeConstants.none;
        },
      );
    }
    return SizeConstants.none;
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
  void _addAttachmentSheet() async {
    String? link = await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: DecorationConstants.roundedRectangleBorderTop,
      builder: (_) => BaseBottomModalSheet(
        context: context,
        child: const AddAttachmentPage(),
      ),
    );

    if (link != null && link.trim().isNotEmpty) {
      attachmentCards.add(AttachmentDm(data: link));
      setState(() {});
    }
  }

  // Function to delete an long pressed attachment card.
  void _deleteAttachment(int index) {
    attachmentCards.removeAt(index);
    setState(() {});
  }
}
