import 'package:attendance/components/defaultText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constants {
  static final Color primaryColor = Color(0xFF2296f3);
  static final Color backgroundColor = Color(0xFFc5e5FF);

  static Future<dynamic> DialogBox(
      context, String? text, Color? color, IconData? icon) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: color,
              content: SizedBox(
                height: 180.0,
                child: Column(
                  children: [
                    Icon(
                      icon,
                      size: 70.0,
                      color: Constants.backgroundColor,
                    ),
                    const SizedBox(height: 20.0),
                    DefaultText(
                      size: 20.0,
                      text: text!,
                      color: Colors.white,
                      align: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ));
  }
}

String time() {
  return "${DateTime.now().hour < 10 ? "0${DateTime.now().hour}" : DateTime.now().hour} : ${DateTime.now().minute < 10 ? "0${DateTime.now().minute}" : DateTime.now().minute} : ${DateTime.now().second < 10 ? "0${DateTime.now().second}" : DateTime.now().second} ";
}
