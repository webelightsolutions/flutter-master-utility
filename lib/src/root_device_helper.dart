import 'package:root_jailbreak_sniffer/rjsniffer.dart';

/// Add following lines to the Info.plist file in /ios/Runner/ folder.
/// Starting from rjsniffer 1.1.4 iOSSecuritySuite has been pinned to 1.9.10 for license issues.

/// ```
/// <key>LSApplicationQueriesSchemes</key>
/// <array>
///     <string> undecimus</string>
///     <string> sileo</string>
///     <string> zbra</string>
///     <string> filza</string>
///     <string> activator</string>
/// </array>
/// ```

class RootDeviceHelper {
  RootDeviceHelper._();
  static final RootDeviceHelper instance = RootDeviceHelper._();

  Future<bool> get isJailBroken async {
    return await Rjsniffer.amICompromised() ?? false;
  }

  Future<bool> get isDebugged async {
    return await Rjsniffer.amIDebugged() ?? false;
  }

  Future<bool> get isEmulator async {
    return await Rjsniffer.amIEmulator() ?? false;
  }
}
