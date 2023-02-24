import 'package:attendance/components/defaultText.dart';
import 'package:attendance/locator.dart';
import 'package:attendance/models/attendance_slot.dart';
import 'package:attendance/models/studentFace.dart';
import 'package:attendance/services/cameraService.dart';
import 'package:attendance/services/faceDetectorService.dart';
import 'package:attendance/services/mlService.dart';
import 'package:attendance/services/remoteServices.dart';
import 'package:attendance/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class MarkAttendance extends StatefulWidget {
  const MarkAttendance({Key? key}) : super(key: key);

  @override
  State<MarkAttendance> createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  MLService _mlService = locator<MLService>();
  FaceDetectorService _mlKitService = locator<FaceDetectorService>();
  CameraService _cameraService = locator<CameraService>();
  late Future<List<AttendanceSlot?>> futureAttendanceSlot;

  late List<StudentFace?>? stdFace;
  List? face = [];

  _getStudentFace() async {
    stdFace = await RemoteService().studentFace();
    if (stdFace != null) {
      setState(() {
        for (var f in stdFace!) {
          face!.add(f!.studentFace);
        }
      });
    }
  }

  @override
  void initState() {
    futureAttendanceSlot = RemoteService().attendanceSlot();
    _getStudentFace();
    super.initState();
    _initializeServices();
  }

  _initializeServices() async {
    await _cameraService.initialize();
    await _mlService.initialize();
    _mlKitService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: CustomPaint(
                size: Size(size.width, 500),
                painter: MarkAttendancePaint(),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 70.0, left: 10.0, right: 10.0, bottom: 10.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DefaultText(
                      size: 20.0,
                      text: "Mark Attendance",
                      color: Constants.primaryColor,
                    ),
                    const SizedBox(height: 25.0),
                    face!.isNotEmpty
                        ? Container()
                        : GestureDetector(
                            onTap: () async {
                              Navigator.pushNamed(context, '/registerFace');
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                color: Colors.redAccent,
                              ),
                              child: const ListTile(
                                title: Text('Register Face'),
                                trailing: Icon(FontAwesomeIcons.angleRight),
                              ),
                            ),
                          ),
                    const SizedBox(height: 20.0),
                    //card to mark attendance
                    GestureDetector(
                      onTap: () {
                        face!.isEmpty
                            ? showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Register Face"),
                                  content: const Text(
                                      "Oops!, You need to register your face before you can take attendance"),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('OK'))
                                  ],
                                ),
                              )
                            : Navigator.pushNamed(
                                context, '/markAttendanceFace');
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 30.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          color: Constants.backgroundColor,
                        ),
                        child: ListTile(
                          title: const Text('Course Name'),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              Text('Course Title'),
                              Text('Time Range')
                            ],
                          ),
                          trailing: const Icon(FontAwesomeIcons.angleRight),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20.0),
                    FutureBuilder<List<AttendanceSlot?>>(
                        future: futureAttendanceSlot,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var slots = snapshot.data;
                            var format = DateFormat("HH:mm");
                            var now = DateTime.now();
                            // var start = format.parse(slots[0]!.startTime);
                            // var end = format.parse(slots[0]!.endTime);
                            print("now - $now");
                            return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: slots == null ? 0 : slots.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 30.0),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(10.0)),
                                    color: Constants.backgroundColor,
                                  ),
                                  child: ListTile(
                                    title: Text(slots![index]!.courseId),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Text('Course Title'),
                                        Text(slots[index]!.endTime)
                                      ],
                                    ),
                                    trailing: const Icon(FontAwesomeIcons.angleRight),
                                  ),
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            print('no data');
                          }
                          return const CircularProgressIndicator();
                        })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MarkAttendancePaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Constants.primaryColor
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(size.width * 0.0006667, size.height * -0.0001406);
    path.quadraticBezierTo(size.width * 0.0116389, size.height * 0.1401719,
        size.width * 0.1878056, size.height * 0.1595781);
    path.cubicTo(
        size.width * 0.2707222,
        size.height * 0.1712188,
        size.width * 0.3367500,
        size.height * 0.0933750,
        size.width * 0.4947222,
        size.height * 0.0995781);
    path.cubicTo(
        size.width * 0.5916944,
        size.height * 0.1121094,
        size.width * 0.5736667,
        size.height * 0.1817813,
        size.width * 0.7538889,
        size.height * 0.2062187);
    path.quadraticBezierTo(
        size.width * 0.8899167, size.height * 0.2114531, size.width, 0);
    path.lineTo(size.width * 0.0006667, size.height * -0.0001406);
    path.close();

    // Path path = Path()..moveTo(0, 0);
    // path.quadraticBezierTo(size.width * 0.2, 100, size.width * 0.35, 70);

    // path.lineTo(size.width * 0.50, 20);
    // path.arcToPoint(Offset(size.width * 0.60, 20),
    //     radius: Radius.circular(3.0));
    // path;
    // // path.quadraticBezierTo(size.width * 0.55, 15, size.width * 0.60, 30);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
