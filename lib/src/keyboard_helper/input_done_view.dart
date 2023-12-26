import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputDoneView extends StatelessWidget {
  final bool isNext;
  final bool isPrevious;
  final bool isShowButton;
  const InputDoneView({
    this.isNext = false,
    this.isPrevious = false,
    this.isShowButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade100,
      child: Align(
        alignment: Alignment.topRight,
        child: Row(
          mainAxisAlignment: isShowButton ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
          children: [
            if (isShowButton)
              Row(
                children: [
                  const SizedBox(width: 15.0),
                  GestureDetector(
                    onTap: isPrevious ? () => FocusManager.instance.primaryFocus?.previousFocus() : null,
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      color: isPrevious ? Colors.black : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  GestureDetector(
                    onTap: isNext ? () => FocusManager.instance.primaryFocus?.nextFocus() : null,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: isNext ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 2),
              child: CupertinoButton(
                padding: const EdgeInsets.only(right: 24, top: 2, bottom: 2),
                onPressed: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: const Text(
                  "Done",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
