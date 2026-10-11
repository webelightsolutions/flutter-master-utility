import 'package:master_utility/src/log/log.dart';

class ClickGuard {
  ClickGuard._();
  static DateTime? _userClicked;
  static bool isClickRestricted({int threshold = 800}) {
    final now = DateTime.now();
    final inMilliseconds = now.difference(_userClicked ?? now).inMilliseconds;
    if (inMilliseconds > threshold) {
      LogHelper.logSuccess('User:- First Click $inMilliseconds');
      _userClicked = now;
      return false;
    } else {
      LogHelper.logSuccess('User:- Second Click $inMilliseconds');
      return true;
    }
  }
}
