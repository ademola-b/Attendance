import 'package:attendance/screens/student/dashboard.dart';
import 'package:attendance/screens/student/mark_attendance.dart';
import 'package:attendance/screens/general/more.dart';
import 'package:attendance/screens/student/performance.dart';
import 'package:attendance/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentNav extends StatefulWidget {
  const StudentNav({Key? key}) : super(key: key);

  @override
  State<StudentNav> createState() => _StudentNavState();
}

class _StudentNavState extends State<StudentNav> {
  int currentIndex = 0;

  List<IconData> navigationIcons = [
    FontAwesomeIcons.houseUser,
    FontAwesomeIcons.clipboardUser,
    FontAwesomeIcons.receipt,
    FontAwesomeIcons.grip
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [StudentDashboard(), MarkAttendance(), Performance(), More()],
      ),
      bottomNavigationBar: Container(
        height: 60,
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(2, 2),
              )
            ]),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(40.0)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < navigationIcons.length; i++) ...<Expanded>{
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = i;
                      });
                    },
                    child: Container(
                      width: size.width,
                      height: size.height,
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              navigationIcons[i],
                              color: i == currentIndex
                                  ? Constants.primaryColor
                                  : Colors.black54,
                              size: i == currentIndex ? 28 : 24,
                            ),
                            i == currentIndex
                                ? Container(
                                    height: 4,
                                    width: 29,
                                    margin: EdgeInsets.only(top: 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(14.0)),
                                      color: Constants.primaryColor,
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              }
            ],
          ),
        ),
      ),
    );
  }
}
