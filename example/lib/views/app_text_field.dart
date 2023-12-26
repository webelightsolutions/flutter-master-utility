import 'package:flutter/material.dart';
import 'package:master_utility/master_utility.dart';

class AppTextField extends StatelessWidget {
  final FocusNode focusNode;
  final String label;
  final bool isNextButton;
  final bool isPrevious;
  final bool showDoneKeyboard;
  const AppTextField({
    super.key,
    required this.focusNode,
    required this.label,
    this.isNextButton = false,
    this.isPrevious = false,
    this.showDoneKeyboard = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextFormField(
        focusNode: showDoneKeyboard
            ? (focusNode
              ..addListener(() {
                final hasFocus = focusNode.hasFocus;
                if (hasFocus) {
                  KeyboardOverlay.showOverlay(
                    context: context,
                    isNextButton: isNextButton,
                    isPrevious: isPrevious,
                    isShowButton: (isNextButton || isPrevious),
                  );
                } else {
                  KeyboardOverlay.removeOverlay();
                }
              }))
            : focusNode,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}
