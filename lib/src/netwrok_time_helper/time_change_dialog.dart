import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:master_utility/master_utility.dart';

class TimeChangeDialog extends StatefulWidget {
  const TimeChangeDialog({required this.isDialogOpen, super.key});
  final ValueNotifier<bool> isDialogOpen;

  @override
  _TimeChangeDialogState createState() => _TimeChangeDialogState();

  Future<void> show() async {
    await showDialog<void>(
      barrierDismissible: false,
      useSafeArea: false,
      context: NavigationService.context,
      builder: (context) => this,
    );
  }
}

class _TimeChangeDialogState extends State<TimeChangeDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Dialog.fullscreen(
          backgroundColor: Theme.of(NavigationService.context).primaryColor,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.timer_sharp,
                  size: 100,
                  color: Colors.red,
                ),
                Padding(
                  padding: const EdgeInsets.all(20).copyWith(bottom: 10),
                  child: const Text(
                    "Clock is behind",
                    style: TextStyle(
                        fontSize: 25,
                        color: Color(0xFFF0ECE9),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20).copyWith(top: 10),
                  child: const Text(
                    'Your Device date and time is inaccurate! Adjust your clock and try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFF0ECE9),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: FilledButton(
                    style:
                        FilledButton.styleFrom(backgroundColor: Colors.yellow),
                    child: Text(
                      Platform.isAndroid ? 'Update Time' : 'Ok',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    onPressed: () async {
                      if (isClickRestricted) {
                        return;
                      }
                      try {
                        Platform.isAndroid
                            ? await AppSettings.openAppSettings(
                                type: AppSettingsType.date)
                            : exit(0);
                      } on PlatformException catch (e) {
                        LogHelper.logError(
                            "Failed to open time settings: '${e.message}'.");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  static DateTime? _userClicked;

  static bool get isClickRestricted {
    final now = DateTime.now();
    final inMilliseconds = now.difference(_userClicked ?? now).inMilliseconds;
    if (_userClicked == null || inMilliseconds > 800) {
      _userClicked = now;
      return false;
    } else {
      return true;
    }
  }
}
