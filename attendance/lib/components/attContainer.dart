import 'package:flutter/material.dart';

class AttContainer extends StatelessWidget {
  final String desc;
  const AttContainer({
    Key? key,
    required this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.4,
      height: 200,
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.all(10.0),
      // width: wid,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Colors.white,
      ),
      child: Text(
        desc,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15.0),
      ),
    );
  }
}
