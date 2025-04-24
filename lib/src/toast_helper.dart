// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
import 'package:master_utility/master_utility.dart';

enum ToastType { success, info, error }

class ToastHelper {
  /// Show deafult TOAST
  static void showToast({required String message}) {
    if (message.isNotEmpty && message != "null") {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor:
            Theme.of(NavigationService.navigatorKey.currentContext!)
                .colorScheme
                .surface,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  /// Show success TOAST
  static void successToast({
    required String message,
    Color? textColor,
    Color? backgroundColor,
    double? fontSize,
    ToastGravity? gravity,
    Toast? toastLength,
  }) {
    if (message.isNotEmpty && message != "null") {
      showCustomToast(
        message: message,
        backgroundColor: backgroundColor ?? _getToastColor(ToastType.success),
      );
    }
  }

  /// Show error TOAST
  static void errorToast({
    required String message,
    Color? textColor,
    Color? backgroundColor,
    double? fontSize,
    ToastGravity? gravity,
    Toast? toastLength,
  }) {
    if (message.isNotEmpty && message != "null") {
      showCustomToast(
        message: message,
        backgroundColor: backgroundColor ?? _getToastColor(ToastType.error),
      );
    }
  }

  /// Show info TOAST
  static void infoToast({
    required String message,
    Color? textColor,
    Color? backgroundColor,
    double? fontSize,
    ToastGravity? gravity,
    Toast? toastLength,
  }) {
    if (message.isNotEmpty && message != "null") {
      showCustomToast(
        message: message,
        backgroundColor: backgroundColor ?? _getToastColor(ToastType.info),
      );
    }
  }

  /// Show custom TOAST
  static void showCustomToast({
    required String message,
    Color? backgroundColor,
    Color? textColor,
    double? fontSize,
    ToastGravity? gravity,
    Toast? toastLength,
  }) {
    if (message.isNotEmpty && message != "null") {
      Fluttertoast.showToast(
        msg: message,
        toastLength: toastLength ?? Toast.LENGTH_SHORT,
        gravity: gravity ?? ToastGravity.BOTTOM,
        backgroundColor: backgroundColor ?? Colors.black.withValues(alpha: 0.7),
        textColor: textColor ?? Colors.white,
        fontSize: fontSize ?? 14.0,
      );
    }
  }

  static Color _getToastColor(ToastType type) {
    switch (type) {
      case ToastType.success:
        return Colors.green;
      case ToastType.error:
        return Colors.redAccent;
      case ToastType.info:
        return Colors.blue;
    }
  }
}
