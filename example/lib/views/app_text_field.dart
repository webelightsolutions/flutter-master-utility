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
        padding: const EdgeInsets.all(20.0),
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
                  ),
                )));
  }
}
