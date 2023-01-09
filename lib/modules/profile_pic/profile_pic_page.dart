import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:re_vision/base_widgets/base_circle_avatar.dart';
import 'package:re_vision/base_widgets/base_elevated_button.dart';
import 'package:re_vision/constants/color_constants.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/constants/size_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:re_vision/modules/profile_pic/camera_page.dart';
import 'package:re_vision/routes/route_constants.dart';
import 'package:re_vision/utils/cloud/base_storage.dart';
import 'package:re_vision/utils/permission_handler_util.dart';

import '../../base_widgets/base_text.dart';
import '../../constants/string_constants.dart';
import '../../models/user_dm.dart';
import '../../utils/cloud/base_cloud.dart';
import '../../utils/cloud/cloud_constants.dart';

class ProfilePicArguments {
  final User user;
  final String username;

  ProfilePicArguments({required this.user, required this.username});
}

class ProfilePicPage extends StatefulWidget {
  const ProfilePicPage({
    Key? key,
    required this.user,
    required this.username,
  }) : super(key: key);

  final User user;
  final String username;

  @override
  State<ProfilePicPage> createState() => _ProfilePicPageState();
}

class _ProfilePicPageState extends State<ProfilePicPage> {
  /// The selected file.
  String? _selectedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const BaseText(
              StringC.selectPicForProfile,
              fontWeight: FontWeight.w300,
              fontSize: 20,
            ),
            SizeC.spaceVertical10,
            if (_selectedFile != null)
              Stack(
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorC.primary),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: FileImage(File(_selectedFile!)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -5,
                    right: 20,
                    child: CircleAvatar(
                      backgroundColor: ColorC.white,
                      child: IconButton(
                        onPressed: () async {
                          File file = File(_selectedFile!);
                          await file.delete();
                          _selectedFile = null;
                          setState(() {});
                        },
                        color: ColorC.primary,
                        icon: IconC.repeat,
                      ),
                    ),
                  )
                ],
              ),
            if (_selectedFile == null) _selectPicture(),
            SizeC.spaceVertical10,

            // The continue button.
            BaseElevatedButton(
              backgroundColor:
                  (_selectedFile != null && _selectedFile!.isNotEmpty)
                      ? ColorC.secondary
                      : ColorC.shadowColor,
              onPressed: (_selectedFile != null && _selectedFile!.isNotEmpty)
                  ? () async {
                      // Update the profile pic.
                      try {
                        String? downloadUrl =
                            await FBStorageSingleton.instance.upload(
                          bucketPath: "profile_pics",
                          contentPath: widget.user.email ?? "unknown",
                          file: File(_selectedFile!),
                        );

                        await widget.user.updatePhotoURL(downloadUrl);

                        _saveUserToCloud(widget.user, downloadUrl ?? "");

                        // Navigate to the dashboard page.
                        if (!mounted) return;
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          RouteC.dashboard,
                          (route) => false,
                        );
                      } catch (e) {
                        // todo: failed profile pic update.
                      }
                    }
                  : () {},
              child: const BaseText(StringC.continue_, color: ColorC.white),
            ),
            SizeC.spaceVertical10,

            // The Skip button.
            BaseElevatedButton(
              backgroundColor: ColorC.secondary,
              onPressed: () {
                _saveUserToCloud(widget.user, "");

                Navigator.of(context).pushNamedAndRemoveUntil(
                    RouteC.dashboard, (route) => false);
              },
              child: const BaseText(StringC.skip, color: ColorC.white),
            )
          ],
        ).paddingHorizontal8().center(),
      ),
    );
  }

  Widget _selectPicture() {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            // Ask for permission.
            PermissionStatus status = await PermissionHandlerUtil.instance
                .request(Permission.camera, context: context);

            // Guard the permission response.
            if (status != PermissionStatus.granted) return;

            // Get the camera.
            final cameras = await availableCameras();

            if (!mounted) return;

            // Navigate to the camera page.
            var filePath = await Navigator.of(context).pushNamed(
              RouteC.camera,
              arguments: CameraPageArguments(camera: cameras[1]),
            );

            if (filePath == null) return;

            _selectedFile = filePath as String;
            setState(() {});
          },
          child: const BaseCircleAvatar(
            radius: 100,
            backgroundColor: ColorC.white,
            borderColor: ColorC.primary,
            child: Icon(Icons.camera_alt),
          ),
        ),
        SizeC.spaceVertical10,
        InkWell(
          onTap: () async {
            // Ask for media permission.
            PermissionStatus status = await PermissionHandlerUtil.instance
                .request(
                    Platform.isAndroid ? Permission.storage : Permission.photos,
                    context: context);

            // Guard the permission status.
            if (status != PermissionStatus.granted) return;

            try {
              FilePickerResult? res = await FilePicker.platform
                  .pickFiles(allowMultiple: false, type: FileType.image);

              // Guard the result of picker.
              if (res == null) return;

              // Setting the selected file.
              _selectedFile = res.files.first.path;

              setState(() {});
            } catch (_) {
              // Permission failure.
            }
          },
          child: const BaseCircleAvatar(
            borderColor: ColorC.primary,
            radius: 100,
            backgroundColor: ColorC.white,
            child: IconC.image,
          ),
        ),
      ],
    );
  }

  // --------------------------- Class methods ---------------------------------

  Future<void> _saveUserToCloud(User user, String downloadURL) async {
    // Modelling the data.
    UserFBDm dataToSave = UserFBDm(
      name: widget.username,
      email: user.email,
      picURL: downloadURL,
    );

    // Creating the main collection.
    BaseCloud.create(
      collection: CloudC.users,
      document: user.uid,
      data: dataToSave.toJson(),
    );

    // Update the user name of the user.
    await user.updateDisplayName(widget.username);
  }
}
