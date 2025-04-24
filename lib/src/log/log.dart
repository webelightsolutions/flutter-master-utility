// Dart imports:
import 'dart:developer';

// Flutter imports:
import 'package:flutter/foundation.dart';
// Project imports:
import 'package:master_utility/src/log/stack_trace.dart';

class LogHelper {
  /// For disable log | For set variable use [setIsLogVisible] method in `` void main(){} ``
  /// ```
  /// bool isLogVisible = true;
  /// ```
  static bool _isLogVisible = true;
  bool get isLogVisible => _isLogVisible;
  static void setIsLogVisible({required bool isLogVisible}) {
    _isLogVisible = isLogVisible;
  }

  static bool get _isDebugMode => kDebugMode;

  /// SHOW LOG INFO
  static void logInfo(dynamic msg, {StackTrace? stackTrace}) {
    if (_isDebugMode) {
      if (stackTrace != null) {
        if (_isLogVisible) {
          CustomTrace programInfo = CustomTrace(stackTrace);
          log('\x1B[94m ${[programInfo.fileName]} ${[
            programInfo.functionName
          ]} at ${programInfo.lineNumber} | $msg\x1B[0m');
        }
      } else {
        log('\x1B[94m $msg\x1B[0m');
      }
    }
  }

  /// [logSuccess] print Green Color
  static void logSuccess(dynamic msg, {StackTrace? stackTrace}) {
    if (_isDebugMode) {
      if (stackTrace != null) {
        if (_isLogVisible) {
          CustomTrace programInfo = CustomTrace(stackTrace);
          log('\x1B[92m ${[programInfo.fileName]} ${[
            programInfo.functionName
          ]} at ${programInfo.lineNumber} | $msg\x1B[0m');
        }
      } else {
        if (_isDebugMode) log('\x1B[92m$msg\x1B[0m');
      }
    }
  }

  /// [logWarning] print Yellow Color
  static void logWarning(dynamic msg, {StackTrace? stackTrace}) {
    if (_isDebugMode) {
      if (stackTrace != null) {
        if (_isLogVisible) {
          CustomTrace programInfo = CustomTrace(stackTrace);
          log('\x1B[33m ${[programInfo.fileName]} ${[
            programInfo.functionName
          ]} at ${programInfo.lineNumber} | $msg\x1B[0m');
        }
      } else {
        if (_isDebugMode) log('\x1B[33m$msg\x1B[0m');
      }
    }
  }

  /// [logError] print Red Color
  static void logError(dynamic msg, {StackTrace? stackTrace}) {
    if (_isDebugMode) {
      if (stackTrace != null) {
        if (_isLogVisible) {
          CustomTrace programInfo = CustomTrace(stackTrace);
          log('\x1B[91m ${[programInfo.fileName]} ${[
            programInfo.functionName
          ]} at ${programInfo.lineNumber} | $msg\x1B[0m');
        }
      } else {
        if (_isDebugMode) log('\x1B[91m$msg\x1B[0m');
      }
    }
  }

  /// [logCyan] print Cyan Color
  static void logCyan(dynamic msg, {StackTrace? stackTrace}) {
    if (_isDebugMode) {
      if (stackTrace != null) {
        if (_isLogVisible) {
          CustomTrace programInfo = CustomTrace(stackTrace);
          log('\x1B[36m ${[programInfo.fileName]} ${[
            programInfo.functionName
          ]} at ${programInfo.lineNumber} | $msg\x1B[0m');
        }
      } else {
        if (_isDebugMode) log('\x1B[36m$msg\x1B[0m');
      }
    }
  }
}
