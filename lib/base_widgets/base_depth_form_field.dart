import 'package:flutter/material.dart';

class BaseTextFormFieldWithDepth extends StatelessWidget {
  const BaseTextFormFieldWithDepth({
    Key? key,
    this.hintText,
    this.labelText,
    this.prefix,
    this.suffix,
    this.controller,
    this.maxLines,
    this.expands, this.focusNode,
  }) : super(key: key);

  final String? hintText;
  final String? labelText;
  final Widget? prefix;
  final Widget? suffix;
  final bool? expands;
  final TextEditingController? controller;
  final int? maxLines;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      expands: expands ?? false,
      controller: controller,
      maxLines: maxLines ?? 1,
      style: Theme.of(context)
          .primaryTextTheme
          .bodyMedium
          ?.copyWith(color: Theme.of(context).primaryColor, fontSize: 14.0),
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefix,
        suffixIcon: suffix,
        floatingLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
        filled: true,
        hintStyle: Theme.of(context)
            .primaryTextTheme
            .bodyText1
            ?.copyWith(color: Colors.grey),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }
}
