import 'package:flutter/cupertino.dart';
import 'package:master_utility/src/keyboard_helper/input_done_view.dart';

class KeyboardOverlay {
  static OverlayEntry? _overlayEntry;

  static void showOverlay({
    required BuildContext context,
    bool isNextButton = false,
    bool isPrevious = false,
    bool isShowButton = false,
  }) {
    if (_overlayEntry != null) {
      return;
    }

    final overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0,
          left: 0,
          child: InputDoneView(
            isNext: isNextButton,
            isPrevious: isPrevious,
            isShowButton: isShowButton,
          ),
        );
      },
    );

    overlayState.insert(_overlayEntry!);
  }

  static void removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }
}
