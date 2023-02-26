import 'package:attendance/components/defaultText.dart';
import 'package:attendance/models/studentDetails.dart';
import 'package:attendance/screens/student/bottomNavBar.dart';
import 'package:attendance/screens/student/mark_attendance.dart';
import 'package:attendance/services/remoteServices.dart';
import 'package:attendance/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Performance extends StatefulWidget {
  const Performance({Key? key}) : super(key: key);

  @override
  State<Performance> createState() => _PerformanceState();
}

class _PerformanceState extends State<Performance> {
  List course = [];
  var dropdownvalue;

  Future _getStudentCourse() async {
    //get username
    var box = await Hive.openBox('userToken');
    String username = box.get('username');
    StudentCourse? stdCourse = await RemoteService().studentCourse(username);
    if (stdCourse != null) {
      setState(() {
        course = stdCourse.courseTitle;
        // print("course - $course");
      });
    }
  }

  @override
  void initState() {
    _getStudentCourse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: CustomPaint(
                  size: Size(size.width, 500),
                  painter: MarkAttendancePaint(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 300.0),
                child: Center(
                    child: Image.asset(
                  "assets/images/Attendance-performance-load.png",
                  scale: 0.2,
                )),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 120.0, left: 30.0, right: 30.0, bottom: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultText(
                        size: 25.0,
                        text: "Performance",
                        color: Constants.primaryColor,
                      ),
                      const Divider(height: 10, thickness: 2.0),
                      const SizedBox(height: 20.0),
                      Center(
                        child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.0)),
                              filled: true,
                              fillColor: Color.fromARGB(255, 147, 185, 216),
                            ),
                            value: dropdownvalue,
                            items: course.map((item) {
                              return DropdownMenuItem(
                                  value: item,
                                  child: DefaultText(
                                    text: item,
                                    size: 18.0,
                                  ));
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                dropdownvalue = newVal;
                              });
                            }),
                      ),
                      const SizedBox(height: 50),
                      const Align(
                          alignment: Alignment.center,
                          child: DefaultText(size: 150.0, text: '%'))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
