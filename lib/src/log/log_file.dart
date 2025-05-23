import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class LogsFile {
  static final LogsFile instance = LogsFile._();
  LogsFile._();

  late File _logFile;

  Future<void> init({String fileName = 'app_log.txt'}) async {
    final directory = await getApplicationDocumentsDirectory();
    _logFile = File('${directory.path}/$fileName');

    if (!await _logFile.exists()) {
      await _logFile.create(recursive: true);
    }

    final now = DateTime.now();
    final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    final divider = '\n============================================================\n';
    final startupMessage = '$divider[$formattedTime] 🚀 APP STARTED$divider\n';

    try {
      await _logFile.writeAsString(startupMessage, mode: FileMode.append);
    } catch (e) {
      if (kDebugMode) {
        print('🛑 Failed to write startup log: $e');
      }
    }
  }

  Future<void> logInfo(String message, [StackTrace? stackTrace]) => _writeLog('INFO', 'ℹ️', message, stackTrace);

  Future<void> logSuccess(String message, [StackTrace? stackTrace]) => _writeLog('SUCCESS', '✅', message, stackTrace);

  Future<void> logWarning(String message, [StackTrace? stackTrace]) => _writeLog('WARNING', '⚠️', message, stackTrace);

  Future<void> logError(String message, [StackTrace? stackTrace]) => _writeLog('ERROR', '❌', message, stackTrace);

  Future<void> _writeLog(String level, String emoji, String message, StackTrace? stackTrace) async {
    final now = DateTime.now();
    final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    final logMessage = '[$formattedTime] [$emoji $level] $message';

    final content = stackTrace != null ? '$logMessage\n📍 StackTrace:\n$stackTrace\n\n' : '$logMessage\n\n';

    try {
      await _logFile.writeAsString(content, mode: FileMode.append);
    } catch (e) {
      if (kDebugMode) {
        print('🛑 Failed to write log: $e');
      }
    }
  }

  Future<File?> getLogsFile() async {
    if (await _logFile.exists()) {
      return File(_logFile.path);
    } else {
      throw Exception('Log file not found');
    }
  }

  Future<String> getLogFilePath() async => _logFile.path;
}
