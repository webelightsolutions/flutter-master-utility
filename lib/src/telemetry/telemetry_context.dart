abstract final class TelemetryContext {
  static const int schemaVersion = 1;

  static Map<String, Object> get attributes => {'schema_version': schemaVersion};
}
