import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:re_vision/base_widgets/base_confirmation_dialog.dart';
import 'package:re_vision/base_widgets/base_rounded_elevated_button.dart';
import 'package:re_vision/base_widgets/base_snackbar.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/string_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/models/topic_dm.dart';
import 'package:re_vision/modules/home_page/home_page.dart';

import '../../base_sqlite/sqlite_helper.dart';
import '../../base_widgets/base_text.dart';
import '../../constants/color_constants.dart';
import '../../constants/date_time_constants.dart';
import '../../routes/route_constants.dart';
import '../topic_page/topic_page.dart';

/// Redirected here from the dashboard. Can be either missed or completed
/// revision list.
///
class OverViewPage extends StatefulWidget {
  const OverViewPage({
    Key? key,
    required this.topics,
    this.isCompleted = true,
    required this.title,
  }) : super(key: key);

  final List<TopicDm> topics;
  final bool isCompleted;
  final String title;

  @override
  State<OverViewPage> createState() => _OverViewPageState();
}

class _OverViewPageState extends State<OverViewPage> {
  late List<TopicDm> topics;

  @override
  void initState() {
    super.initState();

    topics = widget.topics;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BaseText(widget.title),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ListView.builder(
          itemCount: topics.length,
          itemBuilder: (context, i) {
            return InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(
                  RouteC.topicPage,
                  arguments: TopicPageArguments(
                    topicDm: topics[i],
                    fromOverview: true,
                  ),
                );
              },
              child: Card(
                      child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LevelChip(iteration: topics[i].iteration ?? 0),
                      if (topics[i].label != null &&
                          topics[i].label!.isNotEmpty)
                        TopicLabelChip(label: topics[i].label!)
                    ],
                  ),

                  // The topic name.
                  BaseText(topics[i].topic ?? '', fontSize: 18),

                  // The subtitle of the topic.
                  const BaseText(
                    StringC.tapToSeeMore,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w300,
                  ),

                  // The action buttons.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BaseElevatedRoundedButton(
                        onPressed: () {
                          _deleteTask(i);
                        },
                        child: IconC.delete,
                      ),
                      BaseElevatedRoundedButton(
                        onPressed: () {
                          _scheduleAlert(i: i);
                        },
                        child: IconC.reschedule,
                      ),
                    ],
                  ),
                ],
              ).paddingDefault())
                  .paddingHorizontal8(),
            );
          }),
    );
  }

  // ----------------------------- Class methods -------------------------------
  /// To delete tasks.
  void _deleteTask(int i) async {
    bool? done = await showDialog(
          context: context,
          builder: (_) => BaseConfirmationDialog(
              title: StringC.deleteAlert,
              content:
                  Lottie.asset(StringC.lottieDelete, height: 80, width: 80)),
        ) ??
        false;

    if (!done) return;

    try {
      await BaseSqlite.delete(
        tableName: StringC.topicTable,
        where: StringC.id,
        whereArgs: topics[i].id,
      );
    } catch (e) {
      debugPrint(e.toString());
      // todo: catch error.
    }

    topics.removeAt(i);
    setState(() {});
  }

  /// Alert dialog for when the user re-schedule the revision.
  Future<void> _scheduleAlert({
    required int i,
  }) async {
    final bool reschedule = await (showDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
            title: const BaseText(StringC.appName),
            content: Column(
              children: [
                const BaseText(StringC.rescheduleAlert, maxLines: 3),
                Lottie.asset(StringC.lottieReschedule, height: 80)
              ],
            ),
            actions: [
              CupertinoDialogAction(
                child: const BaseText(StringC.reschedule),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              CupertinoDialogAction(
                child: const BaseText(StringC.cancel),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          ),
        )) ??
        false;

    if (!reschedule) return;

    // Show the month picker.
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
              onPrimary: ColorC.secondaryComp,
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

    // Modelling the topic data.
    try {
      TopicDm topicDm =
          topics[i].copyWith(iteration: 1, scheduledTo: datePicked.toString());

      // Updating the local database.
      await BaseSqlite.update(
          tableName: StringC.topicTable,
          data: topicDm,
          where: StringC.id,
          whereArgs: topicDm.id);

      topics.removeAt(i);
      setState(() {});

      // Success snack-bar.
      // ignore: use_build_context_synchronously
      baseSnackBar(context, message: StringC.reSuccess, leading: IconC.success);
    } catch (e) {
      debugPrint(e.toString());
      // ignore: use_build_context_synchronously
      baseSnackBar(context, message: StringC.reFailed, leading: IconC.failed);
    }
  }
}
