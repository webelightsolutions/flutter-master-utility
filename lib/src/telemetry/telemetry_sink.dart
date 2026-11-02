/// Implement this in the app to receive every telemetry event (e.g. save it, or forward it to Mixpanel).
abstract interface class TelemetrySink {
  void onEvent(String event, Map<String, Object> properties);
}
