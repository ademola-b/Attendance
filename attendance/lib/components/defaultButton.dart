import 'package:attendance/components/defaultText.dart';
import 'package:attendance/utils/constants.dart';
import 'package:flutter/material.dart';


class DefaultButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final double textSize;
  final FontWeight? textWeight;
  final Size? size;

  const DefaultButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      required this.textSize,
      this.textWeight,
      this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Constants.primaryColor),
        padding: MaterialStateProperty.all(const EdgeInsets.all(15.0)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      onPressed: () {
        onPressed();
      },
      child: DefaultText(
        size: textSize,
        text: text,
        weight: textWeight,
      ),
    );
  }
}
