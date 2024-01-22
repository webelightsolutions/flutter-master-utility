// Dart imports:
import 'dart:async';
import 'dart:ui';

class DebouncerHelper {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  /// Run the provided action after debouncing based on the specified milliseconds.
  void run(VoidCallback action, {int milliseconds = 300}) {
    timer?.cancel();
    timer = Timer(
      Duration(milliseconds: milliseconds),
      action,
    );
  }
}
