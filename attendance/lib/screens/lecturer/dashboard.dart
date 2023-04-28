import 'dart:async';

import 'package:attendance/components/dateContainer.dart';

import 'package:attendance/components/defaultText.dart';
import 'package:attendance/components/defaultContainer.dart';
import 'package:attendance/models/attendance_slot.dart';
import 'package:attendance/models/userResponse.dart';
import 'package:attendance/screens/student/dashboard.dart';

import 'package:attendance/services/remoteServices.dart';
import 'package:attendance/utils/constants.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class LecturerDashboard extends StatefulWidget {
  const LecturerDashboard({Key? key}) : super(key: key);

  @override
  State<LecturerDashboard> createState() => _LecturerDashboardState();
}

class _LecturerDashboardState extends State<LecturerDashboard> {
  DateTime date = DateTime.now();
  Timer? timer;
  double? indicatorValue;
  String _username = 'Loading...';
  List<AttendanceSlotResponse>? slot;

  final StreamController<List<AttendanceSlotResponse>?> _streamController =
      StreamController();

  Future<AttendanceSlotResponse?> _getAttendanceSlot() async {
    List<AttendanceSlotResponse>? att = await RemoteService.attendanceSlot();
    if (att != null) {
      _streamController.sink.add(att);
    }

    return null;
  }

  updateSlot() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) {setState(() {
        _getAttendanceSlot();
      });}
      
    });
  }

  updateSeconds() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        setState(() {
          indicatorValue = DateTime.now().second / 60;
        });
      }
    });
  }

  Future<UserResponse?> _getUser() async {
    UserResponse? user = await RemoteService().getUser(context);
    if (user != null) {
      setState(() {
        _username = user.username;
      });
    } else {}

    return null;
  }

  @override
  void initState() {
    // _getAttendanceSlot();
    _getUser();
    indicatorValue = DateTime.now().second / 60;
    updateSeconds();
    updateSlot();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Stack(children: [
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
                    width: 100, height: 100))),
        
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  DefaultText(size: 20.0, text: "Hello, \n\t\t\t $_username"),
                  const Spacer(),
                  DefaultText(
                      size: 25, text: time(), color: Constants.primaryColor),
                ],
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
              const SizedBox(height: 20.0),
              const DefaultText(
                size: 22.0,
                text: "Ongoing Class",
              ),
              Divider(
                height: 10,
                thickness: 2.0,
                color: Constants.primaryColor,
              ),
              const SizedBox(height: 20.0),
              StreamBuilder<List<AttendanceSlotResponse>?>(
                  stream: _streamController.stream,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const CircularProgressIndicator();
                      default:
                        if (snapshot.hasData && snapshot.data!.isEmpty) {
                          return DefaultText(
                            size: 20.0,
                            text: 'No ongoing class',
                            color: Constants.primaryColor,
                          );
                        } else if (snapshot.hasError) {
                          return const DefaultText(
                              size: 18.0, text: 'Please wait...');
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return DefaultContainer(
                                      course_name: snapshot
                                          .data![index].courseId.courseTitle,
                                      course_code: snapshot
                                          .data![index].courseId.courseCode,
                                      end_time: snapshot.data![index].endTime);
                                }),
                          );
                        }
                    }
                  }),
            ],
          ),
        ),
      ]),
    );
  }
}
