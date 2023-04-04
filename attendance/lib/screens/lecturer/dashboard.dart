import 'dart:async';

import 'package:attendance/components/dateContainer.dart';

import 'package:attendance/components/defaultText.dart';
import 'package:attendance/components/defaultContainer.dart';
import 'package:attendance/models/attendance_slot.dart';
import 'package:attendance/models/userResponse.dart';

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

  updateSeconds() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        setState(() {
          indicatorValue = DateTime.now().second / 60;
        });
      }
    });
  }

  Future<AttendanceSlotResponse?> _getSlot() async {
    slot = await RemoteService().attendanceSlot();
    if (slot!.isNotEmpty) {
      setState(() {
        print(slot);
      });
    }
    return null;
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
    _getSlot();
    _getUser();
    indicatorValue = DateTime.now().second / 60;
    updateSeconds();
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
      // backgroundColor: Constants.primaryColor,
      body: SingleChildScrollView(
        child: Padding(
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
              const Divider(height: 10, thickness: 2.0),
              const SizedBox(height: 20.0),
              FutureBuilder(
                  future: RemoteService().attendanceSlot(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: slot!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: DefaultContainer(
                                  course_name:
                                  
                                      slot![index].courseId.courseTitle,
                                  course_code: slot![index].courseId.courseCode,
                                  end_time: slot![index].endTime),
                            );
                          });
                    } 
                    return const CircularProgressIndicator();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
