import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  const DialogButton({
    super.key,
    this.onPressed,
    required this.title,
    required this.bgColor,
    required this.fontColor,
  });
  final void Function()? onPressed;
  final String title;
  final Color bgColor;
  final Color fontColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.transparent,
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Text(
          title,
          maxLines: 1,
          style: TextStyle(color: fontColor),
        ),
      ),
    );
  }
}
