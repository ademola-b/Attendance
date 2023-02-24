import 'package:flutter/cupertino.dart';

class Constants {
  static final Color primaryColor = Color(0xFF2296f3);
  static final Color backgroundColor = Color(0xFFc5e5FF);
}

String time() {
    return "${DateTime.now().hour < 10 ? "0${DateTime.now().hour}" : DateTime.now().hour} : ${DateTime.now().minute < 10 ? "0${DateTime.now().minute}" : DateTime.now().minute} : ${DateTime.now().second < 10 ? "0${DateTime.now().second}" : DateTime.now().second} ";
  }


