import 'package:flutter/material.dart';

import 'defaultText.dart';

class DateContainer extends StatelessWidget {
  late String? day, month, year;
  DateContainer({
    Key? key,
    this.day,
    this.month,
    this.year,
  }) : super(key: key);

  // DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0xFF999999),
            offset: Offset(0, 0),
            blurRadius: 2.0,
            spreadRadius: 2.0,
          )
        ],
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: DefaultText(size: 20.0, text: day),
    );
  }
}
