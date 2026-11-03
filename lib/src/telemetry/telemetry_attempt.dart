import 'dart:math';

import 'package:master_utility/master_utility.dart';

class TelemetryAttempt {
  TelemetryAttempt(this.operation, {Map<String, Object> attributes = const {}, this.analytics = true})
    : _attributes = {...TelemetryContext.attributes, ...TelemetryAttributes.safe(attributes)} {
    _stopwatch.start();
    _reportStarted();
  }

  final TelemetryOperation operation;
  final bool analytics;
  final Map<String, Object> _attributes;
  final String _id = _newId();
  final Stopwatch _stopwatch = Stopwatch();
  bool _isFinished = false;

  static final Random _random = Random();

  bool get isFinished => _isFinished;

  Map<String, Object> get _dimensions => {'operation': operation.value, ..._attributes};

  void annotate(Map<String, Object> attributes) => _attributes.addAll(TelemetryAttributes.safe(attributes));

  void fail(ApiException error) {
    final dioError = error.exception;
    final reason = dioError is DioException ? dioError.type.name : 'unexpected';
    final wasCancelled = reason == DioExceptionType.cancel.name;
    final statusCode = error.statusCode ?? 0;

    finish(
      wasCancelled ? TelemetryOutcome.cancelled : TelemetryOutcome.failure,
      attributes: {'reason': reason, if (statusCode > 0) 'status_code': statusCode},
    );
  }

  void finish(TelemetryOutcome outcome, {Map<String, Object> attributes = const {}}) {
    if (_isFinished) return;
    _isFinished = true;
    _stopwatch.stop();
    annotate(attributes);
    _reportCompleted(outcome);
  }

  void _reportStarted() {
    TelemetryReporter.count(TelemetryMetric.operationStarted, _dimensions);
    if (!analytics) return;
    TelemetryReporter.event(TelemetryEvent.operationStarted, {..._dimensions, 'operation_id': _id});
  }

  void _reportCompleted(TelemetryOutcome outcome) {
    final dimensions = {..._dimensions, 'outcome': outcome.name};
    final durationMs = _stopwatch.elapsedMilliseconds;

    TelemetryReporter.count(TelemetryMetric.operationCompleted, dimensions);
    TelemetryReporter.distribution(
      TelemetryMetric.operationDuration,
      durationMs,
      TelemetryUnit.millisecond,
      dimensions,
    );
    if (!analytics) return;
    TelemetryReporter.event(TelemetryEvent.operationCompleted, {
      ...dimensions,
      'operation_id': _id,
      'duration_ms': durationMs,
    });
  }

  static String _newId() => '${DateTime.now().microsecondsSinceEpoch}-${_random.nextInt(1 << 32)}';
}
