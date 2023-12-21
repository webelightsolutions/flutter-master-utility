// Package imports:

// Package imports:
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

// Project imports:
import '../master_utility.dart';

class RootDeviceHelper {
  /// root device checker, it will return true or false.
  static Future<bool> checkJailBreak() async {
    bool jailBroken = false;

    try {
      jailBroken = await FlutterJailbreakDetection.jailbroken;
    } catch (e) {
      jailBroken = true;
    }

    LogHelper.logSuccess("Is device Jailbroken or Rooted : $jailBroken");

    return jailBroken;
  }
}
