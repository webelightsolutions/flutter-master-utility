// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:master_utility/master_utility.dart';
import 'package:master_utility/src/permission_helper/permission_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

enum PermissionType {
  PHOTO,
  CAMERA,
  LOCATION,
  MICROPHONE,
  AUDIO,
  CONTACTS,
  NOTIFICATION,
  SMS,
  PHONE,
  VIDEOS,
}

class PermissionHandlerService {
  /// handle permission based on type and you can also provide your custom dialog for denied permission
  static void handlePermissions({
    required PermissionType type,
    required Function callBack,
    Function? permissionDeniedDialog,
  }) async {
    switch (type) {
      //* PHOTO permission
      case PermissionType.PHOTO:
        if (Platform.isAndroid) {
          AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
          String release = androidInfo.version.release;
          if (int.parse(release) < 13) {
            Permission permission = Permission.storage;
            var status = await permission.status;

            _handlePermission(
              type: type,
              status: status,
              callBack: callBack,
              permission: permission,
              permissionDeniedDialog: permissionDeniedDialog,
            );
          } else {
            Permission permission = Permission.photos;
            var status = await permission.status;

            _handlePermission(
              type: type,
              status: status,
              callBack: callBack,
              permission: permission,
              permissionDeniedDialog: permissionDeniedDialog,
            );
          }
        } else {
          Permission permission = Permission.photos;
          var status = await permission.status;

          _handlePermission(
            type: type,
            status: status,
            callBack: callBack,
            permission: permission,
            permissionDeniedDialog: permissionDeniedDialog,
          );
        }
        break;

      //* CAMERA permission
      case PermissionType.CAMERA:
        Permission permission = Permission.camera;
        var status = await permission.status;
        LogHelper.logCyan(status);
        _handlePermission(
          type: type,
          status: status,
          callBack: callBack,
          permission: permission,
          permissionDeniedDialog: permissionDeniedDialog,
        );
        break;

      //* LOCATION permission
      case PermissionType.LOCATION:
        Permission permission = Permission.location;
        var status = await permission.status;
        LogHelper.logCyan(status);
        _handlePermission(
          type: type,
          status: status,
          callBack: callBack,
          permission: permission,
          permissionDeniedDialog: permissionDeniedDialog,
        );
        break;

      //* MICROPHONE permission
      case PermissionType.MICROPHONE:
        Permission permission = Permission.microphone;
        var status = await permission.status;
        LogHelper.logCyan(status);
        _handlePermission(
          type: type,
          status: status,
          callBack: callBack,
          permission: permission,
          permissionDeniedDialog: permissionDeniedDialog,
        );
        break;

      //* AUDIO permission
      case PermissionType.AUDIO:
        Permission permission = Permission.audio;
        var status = await permission.status;
        LogHelper.logCyan(status);
        _handlePermission(
          type: type,
          status: status,
          callBack: callBack,
          permission: permission,
          permissionDeniedDialog: permissionDeniedDialog,
        );
        break;

      //* AUDIO permission
      case PermissionType.CONTACTS:
        Permission permission = Permission.contacts;
        var status = await permission.status;
        LogHelper.logCyan(status);
        _handlePermission(
          type: type,
          status: status,
          callBack: callBack,
          permission: permission,
          permissionDeniedDialog: permissionDeniedDialog,
        );
        break;

      //* NOTIFICATION permission
      case PermissionType.NOTIFICATION:
        Permission permission = Permission.notification;
        var status = await permission.status;
        LogHelper.logCyan(status);
        _handlePermission(
          type: type,
          status: status,
          callBack: callBack,
          permission: permission,
          permissionDeniedDialog: permissionDeniedDialog,
        );
        break;

      //* SMS permission
      case PermissionType.SMS:
        Permission permission = Permission.sms;
        var status = await permission.status;
        LogHelper.logCyan(status);
        _handlePermission(
          type: type,
          status: status,
          callBack: callBack,
          permission: permission,
          permissionDeniedDialog: permissionDeniedDialog,
        );
        break;

      //* PHONE permission
      case PermissionType.PHONE:
        Permission permission = Permission.phone;
        var status = await permission.status;
        LogHelper.logCyan(status);
        _handlePermission(
          type: type,
          status: status,
          callBack: callBack,
          permission: permission,
          permissionDeniedDialog: permissionDeniedDialog,
        );
        break;

      //* VIDEOS permission
      case PermissionType.VIDEOS:
        Permission permission = Permission.videos;
        var status = await permission.status;
        LogHelper.logCyan(status);
        _handlePermission(
          type: type,
          status: status,
          callBack: callBack,
          permission: permission,
          permissionDeniedDialog: permissionDeniedDialog,
        );
        break;
    }
  }

  static Future<void> _handlePermission({
    required PermissionType type,
    required Function callBack,
    required Permission permission,
    required PermissionStatus status,
    Function? permissionDeniedDialog,
  }) async {
    // Force refresh the permission status to get the current state
    // This is especially important after returning from app settings
    PermissionStatus currentStatus = await permission.status;

    switch (currentStatus) {
      case PermissionStatus.granted:
        callBack();
        break;
      case PermissionStatus.limited:
        Platform.isIOS ? callBack() : null;
        break;
      case PermissionStatus.denied:
        PermissionStatus permissionStatus = await permission.request();
        if (permissionStatus == PermissionStatus.granted) {
          callBack();
        } else if (Platform.isIOS && permissionStatus == PermissionStatus.limited) {
          callBack();
        } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
          // If iOS shows permanently denied after request, show settings dialog
          permissionDeniedDialog?.call() ?? PermissionDialog.openDialog(type: type);
        }
        break;
      case PermissionStatus.permanentlyDenied:
        if (Platform.isIOS) {
          try {
            PermissionStatus permissionStatus = await permission.request();
            if (permissionStatus == PermissionStatus.granted) {
              callBack();
            } else if (permissionStatus == PermissionStatus.limited) {
              callBack();
            } else {
              permissionDeniedDialog?.call() ?? PermissionDialog.openDialog(type: type);
            }
          } catch (e) {
            permissionDeniedDialog?.call() ?? PermissionDialog.openDialog(type: type);
          }
        } else {
          // Android: show settings dialog for permanently denied
          permissionDeniedDialog?.call() ?? PermissionDialog.openDialog(type: type);
        }
        break;
      default:
        // For any other status, try requesting permission
        try {
          PermissionStatus permissionStatus = await permission.request();
          if (permissionStatus == PermissionStatus.granted) {
            callBack();
          } else if (Platform.isIOS && permissionStatus == PermissionStatus.limited) {
            callBack();
          }
        } catch (e) {
          // Handle any errors silently
        }
    }
  }
}
