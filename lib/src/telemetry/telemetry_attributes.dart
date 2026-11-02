import 'package:flutter/foundation.dart';

abstract final class TelemetryAttributes {
  static const Set<String> _allowedKeys = {
    'source',
    'phase',
    'mode',
    'media_type',
    'target',
    'stage',
    'result',
    'reason',
    'retry',
    'destination',
    'permission',
    'action',
    'guide',
    'is_stale',
    'status_code',
  };

  static final RegExp _boundedText = RegExp(r'^[a-zA-Z0-9_.-]{1,80}$');

  /// Keeps only allowed keys with short plain values; in debug, prints what was dropped.
  static Map<String, Object> safe(Map<String, Object> attributes) {
    final kept = <String, Object>{};
    for (final MapEntry(:key, :value) in attributes.entries) {
      if (_allowedKeys.contains(key) && _isBounded(value)) {
        kept[key] = value;
      } else if (kDebugMode) {
        debugPrint('[telemetry] dropped attribute "$key: $value" (key not allowed or value not plain text)');
      }
    }
    return kept;
  }

  static bool _isBounded(Object value) => switch (value) {
    bool() || num() => true,
    final String text => _boundedText.hasMatch(text),
    _ => false,
  };
}
