import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:re_vision/base_widgets/base_bottom_modal_sheet.dart';
import 'package:re_vision/base_widgets/base_depth_form_field.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/date_time_constants.dart';
import 'package:re_vision/constants/decoration_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/models/reqs_dm.dart';
import 'package:re_vision/state_management/topic_cloud/topic_cloud_repo.dart';

import '../../base_widgets/base_elevated_button.dart';
import '../../base_widgets/base_text.dart';
import '../../common_button_cubit/common_button_cubit.dart';

class InvitesPage extends StatefulWidget {
  const InvitesPage({
    Key? key,
    required this.topicInvites,
  }) : super(key: key);

  final List<ReqsDm> topicInvites;

  @override
  State<InvitesPage> createState() => _InvitesPageState();
}

class _InvitesPageState extends State<InvitesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BaseText(StringC.revisionInvites),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: ListView.builder(
        itemCount: widget.topicInvites.length,
        itemBuilder: (ctx, i) {
          return _InvitesTile(
            topicInv: widget.topicInvites[i],
            saveChanges: (val) {
              widget.topicInvites.replaceRange(
                  i, i + 1, [widget.topicInvites[i].copyWith(topic: val)]);
              setState(() {});
            },
          );
        },
      ),
    );
  }
}

class _InvitesTile extends StatefulWidget {
  const _InvitesTile({
    Key? key,
    required this.topicInv,
    required this.saveChanges,
  }) : super(key: key);

  final ReqsDm topicInv;
  final Function(String) saveChanges;

  @override
  State<_InvitesTile> createState() => _InvitesTileState();
}

class _InvitesTileState extends State<_InvitesTile> {
  /// The cubit to fetch the data from the topic collection.
  late final CommonButtonCubit _cubit;

  /// Text form field controllers.
  late final TextEditingController _senderC;
  late final TextEditingController _topicC;
  late final TextEditingController _scheduledC;

  @override
  void initState() {
    super.initState();

    _senderC = TextEditingController();
    _topicC = TextEditingController();
    _scheduledC = TextEditingController();

    // Setting the initial values for the controllers.
    _senderC.text = '${widget.topicInv.name} (${widget.topicInv.email})';
    _topicC.text = widget.topicInv.topic ?? "";
    _scheduledC.text = DateTimeC.yMMMdToday;

    _cubit = CommonButtonCubit(TopicCloudRepo());
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: BaseText("Topic: ${widget.topicInv.topic}"),
      subtitle: const BaseText("Tap to edit details"),
      trailing: _acceptButton(),
      onTap: _onListTap,
    );
  }

  /// Accepted button.
  Widget _acceptButton() {
    return BaseElevatedButton(
      backgroundColor: ColorC.elevatedButton,
      onPressed: _confirmAccept,
      size: const Size(80, 40),
      child: const BaseText(StringC.accept),
    );
  }

  /// Function to perform when the invitation list is tapped.
  void _onListTap() async {
    await showModalBottomSheet(
      shape: DecorC.roundedRectangleBorderTop,
      context: context,
      isScrollControlled: true,
      builder: (_) => SingleChildScrollView(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 10),
        child: BaseModalSheetWithNotch(
          context: context,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BaseTextFormFieldWithDepth(
                readOnly: true,
                labelText: "Sent by",
                controller: _senderC,
              ),
              SizeC.spaceVertical10,
              BaseTextFormFieldWithDepth(
                labelText: "Topic name",
                controller: _topicC,
              ),
              SizeC.spaceVertical10,
              BaseTextFormFieldWithDepth(
                readOnly: true,
                onTap: _datePicker,
                labelText: "Will be scheduled to",
                controller: _scheduledC,
              ),
              SizeC.spaceVertical10,
              BaseElevatedButton(
                backgroundColor: ColorC.elevatedButton,
                size: SizeC.elevatedButton,
                onPressed: () {},
                child: const BaseText(StringC.accept),
              ),
            ],
          ).paddingDefault(),
        ),
      ),
    );

    // Update the topic name.
    widget.saveChanges(_topicC.text);
  }

  // ----------------------------- Function ------------------------------------

  /// Function to render the date picker.
  void _datePicker() async {
    DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: DateTimeC.todayTime,
      firstDate: DateTimeC.todayTime,
      lastDate: DateTimeC.lastDay,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorC.primary,
              onPrimary: ColorC.secondary,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    // Guard the date picked.
    if (datePicked == null) return;

    _scheduledC.text = DateFormat.yMMMMd('en_US').format(datePicked);
    setState(() {});
  }

  /// Confirmation dialog for the when the user accepts the revision invitation.
  void _confirmAccept() async {
    bool confirm = await showDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const BaseText(StringC.appName),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizeC.spaceVertical10,
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  const TextSpan(
                    text: "Are you sure want to save the revision topic: ",
                  ),
                  TextSpan(
                    text: _topicC.text,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizeC.spaceVertical10,
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  const TextSpan(
                    text: "Scheduled to: ",
                  ),
                  TextSpan(
                    text: _scheduledC.text,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const BaseText(StringC.ok),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          CupertinoDialogAction(
            child: const BaseText(StringC.cancel),
            onPressed: () => Navigator.of(context).pop(false),
          )
        ],
      ),
    );

    // Guard the [confirm].
    if (!confirm) return;
  }
}
