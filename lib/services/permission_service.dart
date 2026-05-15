import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestPermissions() async {
    if (!Platform.isAndroid) {
      return true;
    }

    try {
      if (await Permission.audio.isGranted) {
        return true;
      }

      final status = await Permission.audio
          .request()
          .timeout(const Duration(seconds: 8));

      if (status.isPermanentlyDenied) {
        return false;
      }

      return status.isGranted;
    } catch (e) {
      return await Permission.audio.isGranted;
    }
  }

  Future<bool> hasPermissions() async {
    if (!Platform.isAndroid) {
      return true;
    }

    return await Permission.audio.isGranted;
  }

  Future<void> openSettings() async {
    await openAppSettings();
  }
}