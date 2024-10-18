import 'package:flutter/material.dart';
import 'package:master_utility/master_utility.dart';
import 'package:master_utility/src/netwrok_time_helper/time_change_dialog.dart';
import 'package:ntp/ntp.dart';

class TimeSyncHelper {
  TimeSyncHelper._();

  // Method to listen for time changes
  static Future<void> listenForTimeChanges(
      ValueNotifier<bool> isDialogOpen) async {
    try {
      // Get current time from server
      final ntpTime = await NTP.now();
      final systemTime = DateTime.now();
      final difference = systemTime.difference(ntpTime);

      if (difference.abs().inMinutes > 1) {
        LogHelper.logError('System time is incorrect compared to NTP time');

        if (!isDialogOpen.value) {
          isDialogOpen.value = true;
          await TimeChangeDialog(isDialogOpen: isDialogOpen).show();
        }
      } else {
        if (isDialogOpen.value) {
          NavigationHelper.navigatePop();
          isDialogOpen.value = false;
        }
      }
    } catch (error) {
      LogHelper.logError('Failed to get NTP time: $error');
    }
  }
}
