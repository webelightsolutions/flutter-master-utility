abstract final class TelemetryPhase {
  static String ofPage(int page) => page == 1 ? 'first_page' : 'pagination';

  static String ofCursor(String? cursor) => cursor == null ? 'latest' : 'pagination';

  static String ofRefresh({required bool forceRefresh}) => forceRefresh ? 'refresh' : 'initial';
}
