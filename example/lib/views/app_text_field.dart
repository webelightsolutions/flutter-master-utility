import 'package:flutter/material.dart';
import 'package:master_utility/master_utility.dart';

class AppTextField extends StatelessWidget {
  final FocusNode focusNode;
  final String label;
  final bool isNextButton;
  final bool isPrevious;
  final bool showDoneKeyboard;
  final ValueNotifier<bool>? showExtraHeight;

  const AppTextField({
    super.key,
    required this.focusNode,
    required this.label,
    this.isNextButton = false,
    this.isPrevious = false,
    this.showDoneKeyboard = false,
    this.showExtraHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ValueListenableBuilder(
        valueListenable: showExtraHeight!,
        builder: (context, value, child) => TextFormField(
          focusNode: showDoneKeyboard
              ? (focusNode
                ..addListener(() {
                  final hasFocus = focusNode.hasFocus;
                  if (hasFocus) {
                    showExtraHeight?.value = true;
                    KeyboardOverlay.showOverlay(
                      context: context,
                      isNextButton: isNextButton,
                      isPrevious: isPrevious,
                      isShowButton: (isNextButton || isPrevious),
                    );
                  } else {
                    KeyboardOverlay.removeOverlay();
                    showExtraHeight?.value = false;
                  }
                }))
              : focusNode,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: focusNode.hasFocus ? Colors.blue : Colors.grey,
              fontWeight: FontWeight.w600,
            ),
            hintText: 'Enter $label',
            hintStyle: TextStyle(color: Colors.grey.shade600),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          ),
        ),
      ),
    );
  }
}
