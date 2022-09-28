import 'package:favicon/favicon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_vision/base_widgets/base_alert_dialog.dart';
import 'package:re_vision/base_widgets/base_depth_form_field.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/state_management/attachment/attachment_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

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

class _AddAttachment extends StatefulWidget {
  const _AddAttachment({Key? key, this.attachmentDm}) : super(key: key);

  final AttachmentDm? attachmentDm;

  @override
  State<_AddAttachment> createState() => _AddAttachmentState();
}

class _AddAttachmentState extends State<_AddAttachment> {
  AttachmentDm? get _attachmentDm => widget.attachmentDm;

  late bool noAttachment;

  // Function to get the correct type of widget according to the attachment
  // type.
  Future<Widget?> getChild() async {
    if (_attachmentDm?.type == AttachmentType.link) {
      Favicon? imageUrl = await getImageUrl(_attachmentDm);
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(imageUrl?.url ?? '', height: 40.0, width: 40.0),
      );
    }
    return null;
  }

  @override
  void initState() {
    noAttachment = widget.attachmentDm?.data == null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // On Tap will only be enabled when the grid card has no attachment
      // data.
      onTap: noAttachment
          ? _emptyGrid
          : _launchUrl,
      onLongPress: () {
        // To vibrate the phone on a long press.
        HapticFeedback.vibrate();
        print('Long pressed');
      },
      child: Card(
        child: FutureBuilder(
          future: getChild(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CupertinoActivityIndicator();
            } else if (snapshot.hasData) {
              return snapshot.data ?? SizeConstants.none;
            } else if (snapshot.hasError) {
              return IconConstants.noFavIcon;
            }
            return IconConstants.add;
          },
        ),
      ),
    );
  }

  // Function to delete the long pressed attachment card.
  void _deleteAttachment() {
    context
        .read<AttachmentCubit>()
        .removeAttachment(widget.attachmentDm!);
  }

  // Function to get the image from the website url.
  Future<Favicon?> getImageUrl(AttachmentDm? attachment) async {
    return await FaviconFinder.getBest(attachment?.data ?? '');
  }

  // Function to call on tapping a empty grid card.
  void _emptyGrid() async {
    await showDialog(
      context: context,
      builder: (_) => const BaseAlertDialog(
        title: StringConstants.selectAttachmentType,
        customContent: _AttachTypeContainer(),
        actions: [SizeConstants.none],
      ),
    );
  }

  // Function to launch an url.
  void _launchUrl() async {
    try {
      final Uri url = Uri.parse(widget.attachmentDm?.data ?? '');
      await launchUrl(url, mode: LaunchMode.inAppWebView);
    } catch (e) {
      // todo: handle argument error.
      debugPrint('Unable to launch the url: ${widget.attachmentDm?.data}');
      debugPrint(e.toString());
    }
  }
}

class _AttachTypeContainer extends StatefulWidget {
  const _AttachTypeContainer({Key? key}) : super(key: key);

  static final List<AttachmentTypeDm> _attachmentList = [
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
            // Button to cancel adding of link.
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

            // Button to save the added a link.
            TextButton(
              onPressed: () {
                if (_linkPaste.text.isNotEmpty) {
                  context.read<AttachmentCubit>().addAttachment(AttachmentDm(
                      type: AttachmentType.link, data: _linkPaste.text));
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
                  itemCount: _AttachTypeContainer._attachmentList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: _AttachTypeContainer._attachmentList[index].icon,
                      onTap: () {
                        set(() {
                          _addAttachment = !_addAttachment;
                        });
                      },
                      title: BaseText(
                        _AttachTypeContainer._attachmentList[index].title,
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
          SizeConstants.spaceVertical20,
          Expanded(
            child: BlocBuilder<AttachmentCubit, AttachmentState>(
              builder: (context, state) {
                // Adding a empty attachment card.
                List<AttachmentDm> attachments = [AttachmentDm()];
                attachments.addAll(state.attachments);

                // The grid of attachments.
                return GridView.builder(
                  gridDelegate: _gridDelegate,
                  itemCount: attachments.length,
                  itemBuilder: (context, index) {
                    return _AddAttachment(
                      attachmentDm: attachments[index],
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
