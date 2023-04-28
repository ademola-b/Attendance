import 'package:attendance/screens/general/profile.dart';
import 'package:attendance/screens/lecturer/reports.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/constants.dart';
import 'dashboard.dart';
import 'initiate_attendance.dart';
import 'more.dart';

class LecturerNav extends StatefulWidget {
  const LecturerNav({Key? key}) : super(key: key);

  @override
  State<LecturerNav> createState() => _LecturerNavState();
}

class _LecturerNavState extends State<LecturerNav> {
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
      // backgroundColor: Constants.primaryColor,
      body: IndexedStack(
        index: currentIndex,
        children: const [
          LecturerDashboard(),
          InitiateAttendance(),
          Reports(),
          More()
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
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
                              size: i == currentIndex ? 30 : 26,
                            ),
                            i == currentIndex
                                ? Container(
                                    height: 4,
                                    width: 25,
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
