// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Project imports:
import 'package:master_utility/src/log/log.dart';
import 'package:master_utility/src/material/material_widget.dart';

enum NavigationType { MATERIAL, CUPERTINO }

class NavigationHelper {
  static final NavigationHelper _instance = NavigationHelper();
  static NavigationType _type = NavigationType.MATERIAL;

  /// SET NAVIGATION TYPE (MATERIAL,CUPERTINO) by default MATERIAL TYPE
  void setNavigationType(NavigationType? type) {
    if (type != null) {
      _type = type;
    }
  }

  static final BuildContext _context =
      NavigationService.navigatorKey.currentContext!;

  static Future navigatePush({
    required Widget route,

    /// For iOS only
    bool fullscreenDialog = false,
    NavigationType? type,
  }) {
    _instance.setNavigationType(type);

    LogHelper.logSuccess("navigationType:${_type.name} : $route",
        stackTrace: StackTrace.current);

    if (_type == NavigationType.MATERIAL) {
      return Navigator.push(
        _context,
        MaterialPageRoute(
          builder: (context) => route,
        ),
      );
    } else {
      return Navigator.push(
        _context,
        CupertinoPageRoute(
          builder: (context) => route,
          fullscreenDialog: fullscreenDialog,
        ),
      );
    }
  }

  static void navigatePop<T extends Object?>([T? result]) {
    LogHelper.logSuccess('', stackTrace: StackTrace.current);
    return Navigator.pop(_context, result);
  }

  static Future navigatePushReplacement(
      {required Widget route, NavigationType? type}) {
    _instance.setNavigationType(type);

    LogHelper.logSuccess("navigationType:${_type.name} : $route",
        stackTrace: StackTrace.current);

    if (_type == NavigationType.MATERIAL) {
      return Navigator.pushReplacement(
          _context, MaterialPageRoute(builder: (context) => route));
    } else {
      return Navigator.pushReplacement(
        _context,
        CupertinoPageRoute(
          builder: (context) => route,
        ),
      );
    }
  }

  static Future navigatePushRemoveUntil({
    required Widget route,
    NavigationType? type,
    // for iOS only
    bool Function(Route<dynamic>)? predicate,
  }) {
    _instance.setNavigationType(type);

    LogHelper.logSuccess("navigationType:${_type.name} : $route",
        stackTrace: StackTrace.current);

    if (_type == NavigationType.MATERIAL) {
      return Navigator.pushAndRemoveUntil(_context,
          MaterialPageRoute(builder: (context) => route), (route) => false);
    } else {
      final isTrue = predicate == null;

      return Navigator.pushAndRemoveUntil(
        _context,
        CupertinoPageRoute(builder: (context) => route),
        (route) => (isTrue ? !isTrue : predicate(route)),
      );
    }
  }
}
