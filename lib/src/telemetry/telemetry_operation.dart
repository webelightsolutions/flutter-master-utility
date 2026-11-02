/// Apps define their operations as an enum that implements this, e.g.
/// `enum AppOperation implements TelemetryOperation { upload('upload'); ... }`.
class TelemetryOperation {
  const TelemetryOperation(this.value);

  final String value;
}
