import 'package:flutter/foundation.dart';
import 'package:master_utility/src/telemetry/telemetry_sink.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

abstract final class TelemetryReporter {
  static TelemetrySink? _sink;

  static void registerSink(TelemetrySink sink) => _sink = sink;

  static void count(String name, Map<String, Object> attributes) => _sendMetric(name, 1, null, attributes);

  static void distribution(String name, num value, String unit, Map<String, Object> attributes) =>
      _sendMetric(name, value, unit, attributes);

  static void event(String event, Map<String, Object> properties) {
    try {
      _sink?.onEvent(event, properties);
    } on Object catch (error, stackTrace) {
      if (kDebugMode) debugPrint('[telemetry] $error\n$stackTrace');
    }
  }

  static void _sendMetric(String name, num value, String? unit, Map<String, Object> attributes) {
    if (!kReleaseMode) return;
    try {
      final sentryAttributes = _toSentryAttributes(attributes);
      if (unit == null) {
        Sentry.metrics.count(name, value.toInt(), attributes: sentryAttributes);
      } else {
        Sentry.metrics.distribution(name, value, unit: unit, attributes: sentryAttributes);
      }
    } on Object catch (_) {}
  }

  static Map<String, SentryAttribute> _toSentryAttributes(Map<String, Object> attributes) => {
    for (final MapEntry(:key, :value) in attributes.entries)
      key: switch (value) {
        final bool flag => SentryAttribute.bool(flag),
        final int number => SentryAttribute.int(number),
        final double number => SentryAttribute.double(number),
        _ => SentryAttribute.string('$value'),
      },
  };
}
