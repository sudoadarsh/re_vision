import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/date_time_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/models/reqs_dm.dart';
import 'package:re_vision/state_management/topic_cloud/topic_cloud_repo.dart';

import '../../base_widgets/base_elevated_button.dart';
import '../../base_widgets/base_text.dart';
import '../../common_button_cubit/common_button_cubit.dart';

class InvitesPage extends StatelessWidget {
  const InvitesPage({
    Key? key,
    required this.topicInvites,
  }) : super(key: key);

  final List<ReqsDm> topicInvites;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BaseText(StringC.revisionInvites),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: ListView.builder(
        itemCount: topicInvites.length,
        itemBuilder: (ctx, i) {
          return _InvitesTile(
            topicInvites: topicInvites[i],
          );
        },
      ),
    );
  }
}

class _InvitesTile extends StatefulWidget {
  const _InvitesTile({
    Key? key,
    required this.topicInvites,
  }) : super(key: key);

  final ReqsDm topicInvites;

  @override
  State<_InvitesTile> createState() => _InvitesTileState();
}

class _InvitesTileState extends State<_InvitesTile> {
  /// The cubit to fetch the data from the topic collection.
  late final CommonButtonCubit _cubit;

  @override
  void initState() {
    super.initState();

    _cubit = CommonButtonCubit(TopicCloudRepo());
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: BaseText(widget.topicInvites.topic ?? ""),
      subtitle: BaseText("From: ${widget.topicInvites.email}"),
      trailing: _acceptButton(),
    );
  }

  /// Accepted button.
  Widget _acceptButton() {
    return BaseElevatedButton(
      backgroundColor: ColorC.elevatedButton,
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
            title: const BaseText(StringC.revision),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      const TextSpan(text: "The topic "),
                      TextSpan(
                        text: widget.topicInvites.topic ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: " will be added to your revisions.")
                    ],
                  ),
                ),
                SizeC.spaceVertical10,
                BaseText(
                  "Scheduled to: ${DateTimeC.yMMMdToday} (Today)",
                  textAlign: TextAlign.left,
                ),
                GestureDetector(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTimeC.todayTime,
                      firstDate: DateTimeC.todayTime,
                      lastDate: DateTimeC.todayTime.add(
                        const Duration(days: 365),
                      ),
                    );
                  },
                  child: const BaseText(
                    "Change scheduled day",
                    decoration: TextDecoration.underline,
                    color: ColorC.link,
                  ),
                ),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                child: const BaseText(StringC.cancel),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                child: const BaseText(StringC.ok),
                onPressed: () {},
              ),
            ],
          ),
        );
      },
      size: const Size(80, 40),
      child: const BaseText(StringC.accept),
    );
  }
}
