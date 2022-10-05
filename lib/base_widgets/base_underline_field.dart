import 'package:flutter/material.dart';

class BaseUnderlineField extends StatelessWidget {
  const BaseUnderlineField({
    Key? key,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.maxLines,
    this.expands,
    this.focusNode,
    this.obscureText,
  }) : super(key: key);

  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? expands;
  final TextEditingController? controller;
  final int? maxLines;
  final FocusNode? focusNode;
  final bool? obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      expands: expands ?? false,
      obscureText: obscureText ?? false,
      controller: controller,
      maxLines: maxLines ?? 1,
      style: Theme.of(context).primaryTextTheme.bodyMedium,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        floatingLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
        hintStyle: Theme.of(context)
            .primaryTextTheme
            .bodyText1
            ?.copyWith(color: Colors.grey),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white10)),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor)),
      ),
    );
  }
}
