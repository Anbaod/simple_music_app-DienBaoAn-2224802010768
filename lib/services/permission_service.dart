import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class PermissionService {

  Future<bool> requestPermissions() async {

    if (!Platform.isAndroid) {
      return false;
    }

    PermissionStatus status;

    if (await Permission.audio.isGranted) {
      return true;
    }

    status = await Permission.audio.request();

    if (status.isPermanentlyDenied) {

      await openAppSettings();

      return false;
    }

    return status.isGranted;
  }

  Future<bool> hasPermissions() async {

    if (!Platform.isAndroid) {
      return false;
    }

    return await Permission.audio.isGranted;
  }

  Future<void> openSettings() async {

    await openAppSettings();
  }
}