// Package imports:

// Package imports:
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';

// Project imports:
import '../master_utility.dart';

class RootDeviceHelper {
  /// root device checker, it will return true or false.
  static Future<bool> checkJailBreak() async {
    bool jailBroken = false;

    try {
      jailBroken = await JailbreakRootDetection.instance.isJailBroken;
    } catch (e) {
      jailBroken = true;
    }

    LogHelper.logSuccess("Is device Jailbroken or Rooted : $jailBroken");

    return jailBroken;
  }
}
