import 'dart:async';

import 'package:attendance/components/dateContainer.dart';
import 'package:attendance/components/defaultText.dart';
import 'package:attendance/models/performance_response.dart';
import 'package:attendance/models/studentCourse.dart';
// import 'package:attendance/models/studentDetails.dart';
import 'package:attendance/models/userResponse.dart';
import 'package:attendance/services/remoteServices.dart';
import 'package:attendance/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import 'package:pie_chart/pie_chart.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  State<StudentDashboard> createState() => _DashboardState();
}

class _DashboardState extends State<StudentDashboard> {
  DateTime date = DateTime.now();
  double? indicatorValue;
  Timer? timer;
  String? _username = 'Loading...';
  Map<String, double> dataMap = {'key': 100.0};

  List stdCourse = [];
  Courses? _stdCourse;
  UserResponse? user;
  Map<String, double> stdPie = new Map<String, double>();
  // late UserResponse user;
  Future<UserResponse?> _getUser() async {
    UserResponse? user = await RemoteService().getUser(context);
    if (user != null) {
      print(user.username);
      _getStudentDetail(user.username);
      setState(() {
        _username = user.username;
      });

      return user;
    }
    return null;
  }

  Future<Courses?> _getStudentDetail(String username) async {
    Courses? _stdCourse = await RemoteService.studentCourse(username, context);
    if (_stdCourse != null) {
      stdCourse = [...stdCourse, ..._stdCourse.courses];
      print(stdCourse);

      // return _stdCourse;
    }
    return null;
  }

  Future<List<Performance>?>? _getAllPerformance(context) async {
    List<Performance>? performance =
        await RemoteService.getAllPerformance(context);
    if (performance != null) {
      for (var data in performance) {
        print("${data.course} - ${data.performancePercent}");
        setState(() {
          dataMap[data.course] = data.performancePercent;
          // Map<String, double> dataM = dataMap!;
        });
      }
    } else {
      Constants.DialogBox(context, "No attendance record", Colors.amber,
          Icons.info_outline_rounded);
    }
    return null;
  }

  updateSeconds() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        indicatorValue = DateTime.now().second / 60;
      });
    });
  }

  @override
  void initState() {
    _getUser();

    _getAllPerformance(context);
    indicatorValue = DateTime.now().second / 60;
    updateSeconds();
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  // Map<String, double> dataMap = {
  //   "COM411": 23.4,
  //   "COM412": 27.2,
  //   "COM413": 78.2,
  //   "COM414": 75.3,
  //   "COM415": 80.3
  // };

  List<Color> colorsList = [
    Color(0xFFD95A53),
    Constants.backgroundColor,
    Colors.amber,
    Colors.black12,
    Colors.greenAccent
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const DefaultText(text: 'DASHBOARD', size: 22.0),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
              right: -50.0,
              top: 20,
              child: Opacity(
                  opacity: 0.1,
                  child: Image.asset("assets/images/back_time.png",
                      width: 200, height: 200))),
          Positioned(
              left: -30.0,
              bottom: 20,
              child: Opacity(
                  opacity: 0.1,
                  child: Image.asset("assets/images/geo.png",
                      width: 200, height: 200))),
          Positioned(
            bottom: 0,
            right: 0,
            child: CustomPaint(
              size: Size(size.width, 80),
              painter: DashboardPaint(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultText(
                            size: 25.0,
                            text: 'Hello, \n ${_username!.toUpperCase()}'),
                        const Spacer(),
                        DefaultText(
                          size: 25,
                          text: time(),
                          color: Constants.primaryColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DateContainer(day: "${date.day}"),
                      DateContainer(day: DateFormat.MMMM().format(date)),
                      DateContainer(day: "${date.year}"),
                    ],
                  ),
                  const SizedBox(height: 40.0),
                  const DefaultText(
                      size: 22.0, text: "Performance in all courses"),
                  const Divider(height: 10, thickness: 2.0),
                  Expanded(
                    child: PieChart(
                      dataMap: dataMap,
                      colorList: colorsList,
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValuesInPercentage: true,
                        showChartValueBackground: false,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Constants.primaryColor
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(size.width * 0.5, size.height);
    // path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    // path.quadraticBezierTo(
    //     size.width * 0.65, size.height - 100, size.width * 0.20, 80);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
