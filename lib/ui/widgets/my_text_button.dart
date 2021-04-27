import 'package:flutter/material.dart';
import 'package:portoun/ui/widgets/widgets.dart';

class MyTextButton extends StatelessWidget {
  final String? label;
  final void Function()? onPressed;
  final Color? colorText;
  final Color? backgroundColor;

  MyTextButton(
      {required this.label,
      required this.onPressed,
      this.colorText,
      this.backgroundColor});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          primary: colorText,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        child: MyText(
          label: label,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
