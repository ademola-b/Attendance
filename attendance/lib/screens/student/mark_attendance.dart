// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:attendance/components/defaultText.dart';
import 'package:attendance/locator.dart';
import 'package:attendance/models/attendance.dart';
import 'package:attendance/models/attendance_slot.dart';
import 'package:attendance/models/studentFace.dart';
import 'package:attendance/services/cameraService.dart';
import 'package:attendance/services/faceDetectorService.dart';
import 'package:attendance/services/mlService.dart';
import 'package:attendance/services/remoteServices.dart';
import 'package:attendance/utils/constants.dart';
import 'package:easy_geofencing/easy_geofencing.dart';
import 'package:easy_geofencing/enums/geofence_status.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MarkAttendance extends StatefulWidget {
  const MarkAttendance({Key? key}) : super(key: key);

  @override
  State<MarkAttendance> createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  MLService _mlService = locator<MLService>();
  FaceDetectorService _mlKitService = locator<FaceDetectorService>();
  CameraService _cameraService = locator<CameraService>();
  late Future<List<AttendanceSlotResponse?>?> futureAttendanceSlot;

  Position? position;
  bool isReady = false;

  late List<StudentFace?>? stdFace;
  List? face = [];

  StreamSubscription<GeofenceStatus>? geofenceStreamingStatus;
  String geofenceStatus = '';

  final StreamController<List<AttendanceSlotResponse>?> _streamController =
      StreamController();

  getCurrentPosition() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("LOCATION(from att) => ${position!.toJson()}");
    isReady = (position != null) ? true : false;
  }

  Future<AttendanceSlotResponse?> _getAttendanceSlot() async {
    List<AttendanceSlotResponse>? att = await RemoteService.attendanceSlot();
    if (att != null) {
      _streamController.sink.add(att);
    }

    return null;
  }

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

  startStreaming(String latitude, String longitude, String radius) async {
    EasyGeofencing.startGeofenceService(
        pointedLatitude: latitude,
        pointedLongitude: longitude,
        radiusMeter: radius,
        eventPeriodInSeconds: 5);

    geofenceStreamingStatus ??=
        EasyGeofencing.getGeofenceStream()?.listen((GeofenceStatus status) {
      setState(() {
        geofenceStatus = status.toString();
      });
      print(geofenceStatus);
      print("LOCATION(from att) => ${position!.toJson()}");
    });
  }

  stopStreaming() async {
    EasyGeofencing.stopGeofenceService();
    if (geofenceStreamingStatus == null) return;
    geofenceStreamingStatus!.cancel();
    geofenceStreamingStatus = null;
    print("=====Streaming Stopped=====");
  }

  @override
  void dispose() {
    super.dispose();
    stopStreaming();
  }

  void updateSlot() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        setState(() {
          _getAttendanceSlot();
        });
      }
    });
  }

  @override
  void initState() {
    getCurrentPosition();
    print("loaded");
    futureAttendanceSlot = RemoteService.attendanceSlot();
    _initializeServices();
    _getStudentFace();

    updateSlot();
    super.initState();
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
        body: RefreshIndicator(
          onRefresh: (() async {
            await stopStreaming();
            await getCurrentPosition();
            await _getStudentFace();
            await futureAttendanceSlot;
            return;
          }),
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 100.0, left: 10.0, right: 10.0, bottom: 10.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DefaultText(
                        size: 25.0,
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
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  color: Colors.redAccent,
                                ),
                                child: const ListTile(
                                  title: DefaultText(text:'Register Face', size:16.0),
                                  trailing: Icon(FontAwesomeIcons.angleRight),
                                ),
                              ),
                            ),
                      const SizedBox(height: 20.0),
                      Expanded(
                        child: StreamBuilder<List<AttendanceSlotResponse>?>(
                          stream: _streamController.stream,
                          builder: (context, snapdata) {
                            switch (snapdata.connectionState) {
                              case ConnectionState.waiting:
                                return const CircularProgressIndicator();
                              default:
                                if (snapdata.hasData &&
                                    snapdata.data!.isEmpty) {
                                  return DefaultText(
                                    size: 20.0,
                                    text: "Oops!, No Ongoing Attendance",
                                    color: Constants.primaryColor,
                                  );
                                }
                                if (snapdata.hasError) {
                                  return const DefaultText(
                                    size: 18.0,
                                    text: "Please, Wait ",
                                  );
                                } else {
                                  return AttendanceSlotBuild(snapdata.data!);
                                }
                            }
                          },
                        ),
                      ),
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

  Widget AttendanceSlotBuild(List<AttendanceSlotResponse>? attSlot) {
    return ListView.builder(
        itemCount: attSlot!.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              face!.isEmpty
                  ? Constants.DialogBox(
                      context,
                      "Oops!, You need to register your face before you can take attendance",
                      Colors.amber,
                      Icons.camera)
                  : await startStreaming(attSlot[index].latitude,
                      attSlot[index].longitude, attSlot[index].radius);

              if (geofenceStatus == 'GeofenceStatus.exit') {
                await Constants.DialogBox(
                    context,
                    "Oops!, You are not in the class range",
                    Colors.red[700],
                    Icons.location_off_outlined);
                // Navigator.popAndPushNamed(
                //     context, '/studentNav');
              } else if (geofenceStatus == 'GeofenceStatus.enter') {
                List<Attendance>? _att =
                    await RemoteService.getMarkedAttendance(
                        context, attSlot[index].id);
                if (_att != null && _att.isEmpty) {
                  Navigator.pushNamed(context, '/markAttendanceFace',
                      arguments: {'slot_id': attSlot[index].id});
                } else {
                  Constants.DialogBox(
                      context,
                      "You've marked attendance already",
                      Colors.amber,
                      Icons.warning_amber_outlined);
                }
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 30.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                color: Constants.backgroundColor,
              ),
              child: ListTile(
                title: DefaultText(
                  text: attSlot[index].courseId.courseTitle,
                  size: 17.0,
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DefaultText(
                      text: attSlot[index].courseId.courseCode,
                      size: 15.0,
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        const DefaultText(text: "Time Ending", size: 15.0),
                        DefaultText(text: attSlot[index].endTime, size: 15.0),
                      ],
                    )
                  ],
                ),
                trailing: const Icon(FontAwesomeIcons.angleRight),
              ),
            ),
          );
        });
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
