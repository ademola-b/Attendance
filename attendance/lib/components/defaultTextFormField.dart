import 'package:attendance/utils/constants.dart';
import 'package:flutter/material.dart';

class DefaultTextFormField extends StatefulWidget {
  final String hintText;
  final Widget? label;
  final Function()? onTap;
  final double fontSize;
  final IconData? icon;
  final TextEditingController? controller;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final bool? obscureText, enabled;
  final int? maxLines;
  final keyboardInputType;

  const DefaultTextFormField(
      {Key? key,
      required this.hintText,
      this.controller,
      this.icon,
      // required this.onSaved,
      // required this.validator,
      // required this.keyboardInputType,
      this.maxLines,
      this.obscureText,
      required this.fontSize,
      this.enabled,
      this.onTap,
      this.onSaved,
      this.validator,
      this.keyboardInputType,
      this.label})
      : super(key: key);

  @override
  State<DefaultTextFormField> createState() => _DefaultTextFormFieldState();
}

class _DefaultTextFormFieldState extends State<DefaultTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      onSaved: widget.onSaved,
      onTap: widget.onTap,
      controller: widget.controller,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardInputType,
      // validator: (value) => widget.validator(value),
      // onSaved: (value) => widget.onSaved(value),
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Constants.primaryColor, width: 1.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Constants.primaryColor, width: 1.5)),
        focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Constants.primaryColor, width: 1.5)),
        disabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Constants.primaryColor, width: 1.5)),
        fillColor: Colors.white,
        filled: true,
        // prefixIcon: Icon(widget.icon),
        // prefixIconColor: Constants.primaryColor,
        hintText: widget.hintText,
        label: widget.label,
      ),
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: widget.fontSize,
      ),
    );
  }
}
