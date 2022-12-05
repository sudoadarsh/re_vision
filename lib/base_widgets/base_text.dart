import 'package:flutter/material.dart';

class BaseText extends StatelessWidget {
  const BaseText(
    this.text, {
    Key? key,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.overflow,
    this.textAlign,
    this.fontFamily, this.decoration, this.maxLines,
  }) : super(key: key);

  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final String? fontFamily;
  final TextDecoration? decoration;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: fontSize,
        overflow: overflow,
        fontFamily: fontFamily,
        decoration: decoration,
      ),
      textAlign: textAlign,
    );
  }
}
