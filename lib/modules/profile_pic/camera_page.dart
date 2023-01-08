import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:re_vision/base_widgets/base_camera_page.dart';
import 'package:re_vision/base_widgets/base_circle_avatar.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';

import '../../constants/string_constants.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({Key? key, required this.camera}) : super(key: key);

  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BaseText(StringC.takeAPicture),
      ),
      body: SafeArea(
        child: BaseCameraPage(
          camera: camera,
          floatingButton: const BaseCircleAvatar(
            radius: 50,
            borderColor: ColorC.primary,
            child: IconC.camera,
          ),
          callback: (file) {
            // Guard the file.
            if (file == null) return;

            // Pop the location of the selected file.
            Navigator.of(context).pop(file.path);
          },
        ),
      ),
    );
  }
}

class CameraPageArguments {
  final CameraDescription camera;

  CameraPageArguments({required this.camera});
}
