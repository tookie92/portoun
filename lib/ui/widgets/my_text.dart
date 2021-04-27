import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyText extends StatelessWidget {
  final String? label;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  MyText(
      {required this.label,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.overflow,
      this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(label!,
        textAlign: textAlign,
        overflow: overflow,
        style: GoogleFonts.fjallaOne(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        ));
  }
}
