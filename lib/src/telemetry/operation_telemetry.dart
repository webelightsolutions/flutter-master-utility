import 'package:master_utility/master_utility.dart';

abstract final class OperationTelemetry {
  static TelemetryAttempt start(
    TelemetryOperation operation, {
    Map<String, Object> attributes = const {},
    bool analytics = true,
  }) => TelemetryAttempt(operation, attributes: attributes, analytics: analytics);

  static FutureEither<T> run<T>(
    TelemetryOperation operation,
    FutureEither<T> Function() action, {
    Map<String, Object> attributes = const {},
    bool analytics = true,
    TelemetryOutcome Function(T value)? outcomeOf,
    Map<String, Object> Function(T value)? attributesOf,
  }) async {
    final attempt = start(operation, attributes: attributes, analytics: analytics);
    try {
      final result = await action();
      result.fold(
        attempt.fail,
        (value) => attempt.finish(
          outcomeOf?.call(value) ?? TelemetryOutcome.success,
          attributes: attributesOf?.call(value) ?? const {},
        ),
      );
      return result;
    } on Object {
      attempt.finish(TelemetryOutcome.failure, attributes: const {'reason': 'unexpected'});
      rethrow;
    }
  }

  /// Times [action]: success when it returns, failure when it throws (the error is rethrown).
  static Future<T> measure<T>(
    TelemetryOperation operation,
    Future<T> Function() action, {
    Map<String, Object> attributes = const {},
  }) async {
    final attempt = start(operation, attributes: attributes);
    try {
      final result = await action();
      attempt.finish(TelemetryOutcome.success);
      return result;
    } on Object {
      attempt.finish(TelemetryOutcome.failure, attributes: const {'reason': 'unexpected'});
      rethrow;
    }
  }

  static void count(String name, {Map<String, Object> attributes = const {}}) =>
      TelemetryReporter.count(name, _withContext(attributes));

  static void distribution(String name, num value, String unit, {Map<String, Object> attributes = const {}}) {
    if (!value.isFinite || value < 0) return;
    TelemetryReporter.distribution(name, value, unit, _withContext(attributes));
  }

  static void track(String event, [Map<String, Object> properties = const {}]) =>
      TelemetryReporter.event(event, {...TelemetryContext.attributes, ...properties});

  static void actionBlocked({required String reason, String? target}) {
    final attributes = <String, Object>{'reason': reason, 'target': ?target};
    count(TelemetryMetric.actionBlocked, attributes: attributes);
    track(TelemetryEvent.actionBlocked, attributes);
  }

  static void retryRequested(TelemetryOperation operation) {
    count(TelemetryMetric.actionRetried, attributes: {'target': operation.value});
    track(TelemetryEvent.retryRequested, {'operation': operation.value});
  }

  static Map<String, Object> _withContext(Map<String, Object> attributes) => {
    ...TelemetryContext.attributes,
    ...TelemetryAttributes.safe(attributes),
  };
}
