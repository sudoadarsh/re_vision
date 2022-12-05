import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseTextFormFieldWithDepth extends StatelessWidget {
  const BaseTextFormFieldWithDepth({
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
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.readOnly,
    this.inputFormatters,
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
  final String? Function(String? value)? validator;
  final Function(String?)? onChanged;
  final Function(String?)? onFieldSubmitted;
  final VoidCallback? onTap;
  final bool? readOnly;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      inputFormatters: inputFormatters,
      focusNode: focusNode,
      onChanged: onChanged,
      readOnly: readOnly ?? false,
      onFieldSubmitted: onFieldSubmitted,
      expands: expands ?? false,
      obscureText: obscureText ?? false,
      controller: controller,
      maxLines: maxLines ?? 1,
      validator: validator,
      style: Theme.of(context).primaryTextTheme.bodyMedium,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        floatingLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
        filled: true,
        hintStyle: Theme.of(context)
            .primaryTextTheme
            .bodyText1
            ?.copyWith(color: Colors.grey),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }
}
