import 'package:flutter/material.dart';
import 'package:master_utility/master_utility.dart';
import 'package:master_utility/src/permission_helper/dialog_button.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionDialog {
  static void openDialog({required PermissionType type}) {
    DialogHelper.showCustomAlertDialog(
      barrierDismissible: true,
      builder: (BuildContext context, widget) {
        return PopScope(
          onPopInvokedWithResult: (didPop, result) => true,
          child: AlertDialog(
            contentPadding: const EdgeInsets.all(10.0),
            insetPadding: const EdgeInsets.all(30),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: BorderDirectional(
                      bottom: BorderSide(
                          width: 0.6,
                          color: Colors.grey.withValues(alpha: 0.25)),
                    ),
                  ),
                  child: Center(
                      child: Text(
                    permissionMessages[type]?.headerMsg ?? '',
                    style: const TextStyle(color: Colors.brown, fontSize: 20),
                  )),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      permissionMessages[type]?.titleMsg ?? '',
                      style: const TextStyle(fontSize: 17),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      permissionMessages[type]?.subTitleMsg ?? '',
                      style: const TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 1,
                        child: DialogButton(
                          onPressed: () => NavigationHelper.navigatePop(),
                          title: "Cancel",
                          bgColor: Colors.grey.shade100,
                          fontColor: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: DialogButton(
                          title: "Open Settings",
                          bgColor: Colors.grey,
                          fontColor: Colors.white,
                          onPressed: () {
                            NavigationHelper.navigatePop();
                            openAppSettings();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Map<PermissionType, PermissionMessages> permissionMessages = {
    PermissionType.PHOTO: PermissionMessages(
      subTitleMsg: "Please allow photos access",
      titleMsg: "Photos access required to pick image",
      headerMsg: "Photo Permission denied",
    ),
    PermissionType.CAMERA: PermissionMessages(
      subTitleMsg: "Please allow camera access",
      titleMsg: "Camera access required to scan QR code",
      headerMsg: "Camera Permission denied",
    ),
    PermissionType.LOCATION: PermissionMessages(
      subTitleMsg: "Please allow location access",
      titleMsg: "Location access required for better app experience",
      headerMsg: "Location Permission denied",
    ),
    PermissionType.MICROPHONE: PermissionMessages(
      subTitleMsg: "Please allow microphone access",
      titleMsg: "Microphone access required for audio recording",
      headerMsg: "Microphone Permission denied",
    ),
    PermissionType.AUDIO: PermissionMessages(
      subTitleMsg: "Please allow audio access",
      titleMsg: "Audio access required for playing audio",
      headerMsg: "Audio Permission denied",
    ),
    PermissionType.CONTACTS: PermissionMessages(
      subTitleMsg: "Please allow contacts access",
      titleMsg: "Contacts access required for connecting with friends",
      headerMsg: "Contacts Permission denied",
    ),
    PermissionType.NOTIFICATION: PermissionMessages(
      subTitleMsg: "Please allow notification access",
      titleMsg: "Notification access required for timely updates",
      headerMsg: "Notification Permission denied",
    ),
    PermissionType.SMS: PermissionMessages(
      subTitleMsg: "Please allow SMS access",
      titleMsg: "SMS access required for receiving important messages",
      headerMsg: "SMS Permission denied",
    ),
    PermissionType.PHONE: PermissionMessages(
      subTitleMsg: "Please allow phone access",
      titleMsg: "Phone access required for making calls",
      headerMsg: "Phone Permission denied",
    ),
    PermissionType.VIDEOS: PermissionMessages(
      subTitleMsg: "Please allow videos access",
      titleMsg: "Videos access required for viewing multimedia content",
      headerMsg: "Videos Permission denied",
    ),
  };
}

class PermissionMessages {
  final String subTitleMsg;
  final String titleMsg;
  final String headerMsg;

  PermissionMessages({
    required this.subTitleMsg,
    required this.titleMsg,
    required this.headerMsg,
  });
}
