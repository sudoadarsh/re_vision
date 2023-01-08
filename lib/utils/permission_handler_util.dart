// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:re_vision/base_widgets/base_confirmation_dialog.dart';
import 'package:re_vision/base_widgets/base_text.dart';
import 'package:re_vision/constants/string_constants.dart';

class PermissionHandlerUtil {
  /// Singleton pattern.
  PermissionHandlerUtil._();

  static final PermissionHandlerUtil instance = PermissionHandlerUtil._();

  Future<PermissionStatus> request(
    Permission permission, {
    required BuildContext context,
  }) async {
    PermissionStatus status = await permission.request();
    switch (status) {
      case PermissionStatus.permanentlyDenied:
        await _showAppSettingsDialog(context);
        break;

      case PermissionStatus.denied:
        // Do nothing for now.
        break;
      case PermissionStatus.granted:
        // Do nothing for now.
        break;
      case PermissionStatus.restricted:
        // Do nothing for now.
        break;
      case PermissionStatus.limited:
        // Do nothing for now.
        break;
    }

    return permission.status;
  }

  Future<void> _showAppSettingsDialog(BuildContext context) async {
    bool positive = await showCupertinoDialog(context: context, builder: (_)
        {
          return const BaseConfirmationDialog(
              title: StringC.appName,
              content: BaseText(StringC.openAppSettings)
          );
        }
    );

    if (!positive) return;
    await openAppSettings();
  }
}
