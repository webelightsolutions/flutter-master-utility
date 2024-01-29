import 'package:master_utility/src/log/log.dart';

class DoubleClickReduntHelper {
  static DateTime _userClicked = DateTime.now();
  static const int kDoubleClickThreshold = 2000;

  /// Handles the user's double click behavior, restricting multiple clicks within a short time frame.
  static void handleDoubleClick() {
    final now = DateTime.now();
    final inMilliseconds = now.difference(_userClicked).inMilliseconds;

    if (inMilliseconds > kDoubleClickThreshold) {
      LogHelper.logSuccess('User:- First Click $inMilliseconds');
      _userClicked = now;
    } else {
      LogHelper.logSuccess('User:- Second Click $inMilliseconds');
    }
  }
}
