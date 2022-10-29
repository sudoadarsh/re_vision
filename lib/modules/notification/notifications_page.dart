import 'package:flutter/material.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/string_constants.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: const [
              CircleAvatar(
                backgroundColor: ColorC.shadowColor,
                backgroundImage: AssetImage(StringC.friendPath),
              ),
              BaseText(StringC.frRequests)
            ],
          ),
        ],
      ),
    );
  }
}
