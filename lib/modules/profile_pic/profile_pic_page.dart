import 'package:flutter/material.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';

import '../../base_widgets/base_text.dart';

class ProfilePicPage extends StatelessWidget {
  const ProfilePicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const BaseText(
              "Select a picture for your profile",
              fontWeight: FontWeight.w300,
              fontSize: 20,
            ),
            SizeC.spaceVertical10,
            const CircleAvatar(
              radius: 50,
              backgroundColor: ColorC.white,
              child: Icon(Icons.camera_alt),
            ),
            SizeC.spaceVertical10,
            const CircleAvatar(
              radius: 50,
              backgroundColor: ColorC.white,
              child: Icon(Icons.image),
            ),
          ],
        ).center(),
      ),
    );
  }
}
