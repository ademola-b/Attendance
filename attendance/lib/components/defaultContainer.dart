import 'package:attendance/components/defaultText.dart';
import 'package:attendance/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DefaultContainer extends StatelessWidget {
  final String course_name;
  final String course_code;
  final String end_time;
  const DefaultContainer({
    Key? key,
    required this.course_name, required this.course_code, required this.end_time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Constants.backgroundColor,
      ),
      child: ListTile(
        title: DefaultText(size: 15.0, text: course_name),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DefaultText(size: 15.0, text: course_code),
            DefaultText(size: 15.0, text: end_time)
          ],
        ),
        trailing: const Icon(FontAwesomeIcons.angleRight),
      ),
    );
  }
}
