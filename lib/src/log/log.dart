// Dart imports:
import 'dart:developer';
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:logarte/logarte.dart';
import 'package:master_utility/src/log/log_file.dart';
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

  static Logarte? _logarteClient;
  static bool _enableFileLogger = false;

  /// [setConfigurations] set configurations for logarte and logs file
  /// [logarteClient] is the logarte client
  /// [enableFileLogger] is the flag to add logs in file
  static Future<void> setConfigurations({
    Logarte? logarteClient,
    bool enableFileLogger = false,
  }) async {
    _logarteClient = logarteClient;
    _enableFileLogger = enableFileLogger;
    if (_enableFileLogger) await LogsFile.instance.init();
  }

  static Future<File?> getLogsFile() async {
    try {
      return await LogsFile.instance.getLogsFile();
    } catch (e) {
      logError('Failed to share log file: $e');
      return null;
    }
  }

  /// SHOW LOG INFO
  static void logInfo(dynamic msg, {StackTrace? stackTrace}) {
    if (_logarteClient != null) {
      _logarteClient?.log(msg.toString(), stackTrace: stackTrace);
    }
    if (_enableFileLogger) LogsFile.instance.logInfo(msg, stackTrace);

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
    if (_logarteClient != null) {
      _logarteClient?.log(msg.toString(), stackTrace: stackTrace);
    }
    if (_enableFileLogger) LogsFile.instance.logSuccess(msg, stackTrace);

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
    if (_logarteClient != null) {
      _logarteClient?.log(msg.toString(), stackTrace: stackTrace);
    }
    if (_enableFileLogger) LogsFile.instance.logWarning(msg, stackTrace);

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
    if (_logarteClient != null) {
      _logarteClient?.log(msg.toString(), stackTrace: stackTrace);
    }
    if (_enableFileLogger) LogsFile.instance.logError(msg, stackTrace);

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
    if (_logarteClient != null) {
      _logarteClient?.log(msg.toString(), stackTrace: stackTrace);
    }
    if (_enableFileLogger) LogsFile.instance.logInfo(msg, stackTrace);

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
