// Flutter imports:
// Package imports:
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:master_utility/master_utility.dart';

class DialogHelper {
  DialogHelper._();
  static final BuildContext? _context = NavigationService.navigatorKey.currentContext;

  /// SHOW OK DIALOG
  static Future<dynamic> showOkDialog({
    String? title,
    String? message,
    String? okLabel,
  }) async {
    if (_context == null) {
      LogHelper.logError('Context is null', stackTrace: StackTrace.current);
      return Future.value(null);
    }
    if (!(_context!.mounted)) {
      LogHelper.logError('Context is not mounted', stackTrace: StackTrace.current);
      return Future.value(null);
    }
    OkCancelResult result = await showOkAlertDialog(
      context: _context!,
      title: title,
      message: message,
      okLabel: okLabel,
    );
    return result;
  }

  /// SHOW ALERT DIALOG
  static void showCustomAlertDialog({
    String? title,
    String? message,
    String? okLabel,
    Widget Function(BuildContext, Widget)? builder,
    Future<bool> Function(bool)? onWillPop,
    bool barrierDismissible = true,
    bool useActionSheetForIOS = true,
  }) async {
    if (_context == null) {
      LogHelper.logError('Context is null', stackTrace: StackTrace.current);
      return;
    }
    if (!(_context!.mounted)) {
      LogHelper.logError('Context is not mounted', stackTrace: StackTrace.current);
      return;
    }
    return showAlertDialog(
      context: _context!,
      title: title,
      message: message,
      onPopInvokedWithResult: (didPop, result) => onWillPop?.call(didPop),
      barrierDismissible: barrierDismissible,
      useActionSheetForIOS: useActionSheetForIOS,
      builder: builder,
    );
  }

  /// You can change yes and cancel text.
  ///
  ///  its return 0-1 | 0 = ok 1 = cancel
  static Future<dynamic> showOkCancelDialog({
    String? title,
    String? message,
    String? okLabel,
    String? cancelLabel,
  }) async {
    if (_context == null) {
      LogHelper.logError('Context is null', stackTrace: StackTrace.current);
      return Future.value(null);
    }
    if (!(_context!.mounted)) {
      LogHelper.logError('Context is not mounted', stackTrace: StackTrace.current);
      return Future.value(null);
    }
    OkCancelResult result = await showOkCancelAlertDialog(
      context: _context!,
      title: title,
      message: message,
      okLabel: okLabel,
      cancelLabel: cancelLabel,
    );
    return result.index;
  }

  /// IMAGE DIALOG VIEW
  static Future openImageDialog({required String url, double? height, double? width}) async {
    return showDialog(
        context: NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: height,
              width: width,
              child: AppNetworkImage(url: url),
            ),
          );
        });
  }

  /// SHOW ACTION SHEET
  static Future<T?> showActionSheet<T>({
    List<SheetAction<T>>? actions,
    Widget Function(BuildContext, Widget)? builder,
  }) async {
    final T? result = await showModalActionSheet(
      context: NavigationService.navigatorKey.currentContext!,
      actions: actions ?? [],
      builder: builder,
    );
    return result;
  }
}
