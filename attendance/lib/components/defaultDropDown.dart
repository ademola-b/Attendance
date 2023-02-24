import 'package:attendance/components/defaultText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DefaultDropDown extends StatefulWidget {
  final dynamic dropdownvalue;
  final Function(dynamic) onSaved;
  final String? Function(dynamic)? validator;
  final String text;
  final String? value;
  final ValueChanged<dynamic> onChanged;
  final List<DropdownMenuItem<dynamic>> dropdownMenuItemList;
  const DefaultDropDown(
      {super.key,
      this.dropdownvalue,
      required this.onChanged,
      required this.dropdownMenuItemList,
      this.value,
      required this.text, required this.onSaved, this.validator});

  @override
  State<DefaultDropDown> createState() => _DefaultDropDownState();
}

class _DefaultDropDownState extends State<DefaultDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<dynamic>(
      onSaved: widget.onSaved,
      validator: widget.validator,
      decoration: const InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.0)),
        filled: true,
        fillColor: Color.fromARGB(255, 147, 185, 216),
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      ),
      hint: DefaultText(
        size: 15,
        text: widget.text,
      ),
      isExpanded: true,
      value: widget.dropdownvalue,
      items: widget.dropdownMenuItemList,
      onChanged: widget.onChanged,
    );
  }
}
