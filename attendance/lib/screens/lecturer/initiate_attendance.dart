import 'package:attendance/components/defaultButton.dart';
import 'package:attendance/components/defaultDropDown.dart';
import 'package:attendance/components/defaultText.dart';
import 'package:attendance/components/defaultTextFormField.dart';
import 'package:attendance/models/attendance_slot_creation_response.dart';
import 'package:attendance/models/departments_response.dart';
import 'package:attendance/models/lecturers_response.dart';
import 'package:attendance/services/remoteServices.dart';
import 'package:attendance/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

class InitiateAttendance extends StatefulWidget {
  const InitiateAttendance({Key? key}) : super(key: key);

  @override
  State<InitiateAttendance> createState() => _InitiateAttendanceState();
}

class _InitiateAttendanceState extends State<InitiateAttendance> {
  List dept = [];
  List lct = [];
  late String _lat, _lon, _rad, _date, _stme, _entime, _dept, _course;

  TextEditingController startInput = TextEditingController();
  TextEditingController endInput = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController lonController = TextEditingController();
  TextEditingController radController = TextEditingController();

  var dropdownvalue;
  var dropdownvalue1;
  DateTime date = DateTime.now();
  Position? _position;
  final _form = GlobalKey<FormState>();

  Future _getCurrentLocation() async {
    Position position = await _determinePosition();
    setState(() {
      _position = position;
    });
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;
    //turn on user's location
    //check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permissions are denied');
      }
    }

    return Geolocator.getCurrentPosition();
  }

  pickTime() async {
    TimeOfDay? pickedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (pickedTime != null) {
      DateTime parsedTime =
          DateFormat.jm().parse(pickedTime.format(context).toString());
      String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
      return formattedTime;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: DefaultText(
        size: 15,
        text: 'Time is not selected',
      )));
    }
    return null;
  }

  pickStartTime() async {
    String? fmtTime = await pickTime();
    setState(() {
      fmtTime == null
          ? startInput.text = "00:00:00"
          : startInput.text = fmtTime;
    });
  }

  pickEndTime() async {
    String? fmtTime = await pickTime();
    setState(() {
      fmtTime == null ? endInput.text = "00:00:00" : endInput.text = fmtTime;
    });
  }

  Future<List<DeptResponse>> _getDeptList() async {
    List<DeptResponse> deptList = await RemoteService().getDepartmentList();
    if (deptList.isNotEmpty) {
      setState(() {
        // for (var name in _deptList) {
        //   dept.add(name.deptName);
        // }
        dept = deptList;
      });
    }

    return [];
  }

  Future<List<LectResponse>> _getLectDetail() async {
    List<LectResponse> lect = await RemoteService().getLect();
    if (lect.isNotEmpty) {
      setState(() {
        for (var course in lect) {
          lct.add(course.courseId);
        }
      });
    }

    return [];
  }

  Future<AttendanceSlotCreationResponse> _slotCreation() async {
    AttendanceSlotCreationResponse slot = await RemoteService().slotCreation(
        date: DateTime.parse(_date),
        latitude: _lat,
        longitude: _lon,
        radius: _rad,
        departmentId: int.parse(_dept),
        courseId: int.parse(_course),
        startTime: _stme,
        endTime: _entime,
        status: 'ongoing');
    return slot;
  }

  submit() async {
    var isValid = _form.currentState!.validate();
    if (!isValid) return; //do not nothing if is not valid
    //else
    _form.currentState!.save(); //save current state of form
    await _slotCreation();
    //display message
    print("Submitted");
  }

  @override
  void initState() {
    _getLectDetail();
    _getDeptList();
    startInput.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const DefaultText(
          text: 'Initiate Attendance',
          size: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              DefaultText(
                size: 18.0,
                text:
                    "Fill the below form to set the attendance for today's class",
                color: Constants.primaryColor,
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DefaultButton(
                      onPressed: () async {
                        await _getCurrentLocation();
                        latController.text = _position!.latitude.toString();
                        lonController.text = _position!.longitude.toString();
                        radController.text = 100.0.toString();
                      },
                      text: "Get Coordinates",
                      textSize: 15),
                ],
              ),
              const SizedBox(height: 20.0),
              Form(
                key: _form,
                child: Column(
                  children: [
                    DefaultTextFormField(
                      controller: latController,
                      hintText: "Latitude",
                      fontSize: 15.0,
                      onSaved: (newVal) {
                        _lat = newVal!;
                      },
                      validator: (String? value) {
                        if (value!.isEmpty) return "Latitude is required";
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    DefaultTextFormField(
                      controller: lonController,
                      fontSize: 15.0,
                      hintText: 'Longitude',
                      onSaved: (newVal) {
                        _lon = newVal!;
                      },
                      validator: (String? value) {
                        if (value!.isEmpty) return "Longitude is required";
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    DefaultTextFormField(
                      onSaved: (newVal) {
                        _rad = newVal!;
                      },
                      validator: (String? value) {
                        if (value!.isEmpty) return "Radius is required";
                        return null;
                      },
                      controller: radController,
                      hintText: "Radius",
                      fontSize: 15.0,
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: DefaultDropDown(
                            onSaved: (newVal) {
                              _dept = newVal;
                            },
                            // validator: (value) {
                            //   if (value!.isEmpty) return "field is required";
                            //   return null;
                            // },
                            value: dropdownvalue,
                            onChanged: (newVal) {
                              setState(() {
                                dropdownvalue = newVal!;
                                print(dropdownvalue['deptName']);
                              });
                            },
                            dropdownMenuItemList: dept
                                .map((e) => DropdownMenuItem(
                                    value: e['deptName'],
                                    child: DefaultText(
                                      size: 13,
                                      text: e['deptName'],
                                    )))
                                .toList(),
                            text: 'Department',
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: DefaultDropDown(
                            value: dropdownvalue1,
                            onChanged: (newVal) {
                              setState(() {
                                dropdownvalue1 = newVal!;
                              });
                            },
                            dropdownMenuItemList: lct
                                .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: DefaultText(
                                      size: 13,
                                      text: e,
                                    )))
                                .toList(),
                            text: 'Course Code',
                            onSaved: (newVal) {
                              _course = newVal;
                            },
                            // validator: (value) {
                            //   if (value!.isEmpty) return "field is required";
                            //   return null;
                            // },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    DefaultTextFormField(
                      onSaved: (newVal) {
                        _date = newVal!;
                      },
                      validator: (String? value) {
                        if (value!.isEmpty) return "Date is required";
                        return null;
                      },
                      enabled: false,
                      controller: TextEditingController(
                          text:
                              "${date.year}-${date.month.toString().padLeft(2, "0")}-${date.day}"),
                      fontSize: 15.0,
                      hintText: 'Date',
                    ),
                    const SizedBox(height: 20.0),
                    DefaultTextFormField(
                      onSaved: (newVal) {
                        _stme = newVal!;
                      },
                      validator: (String? value) {
                        if (value!.isEmpty) return "Start Time is required";
                        return null;
                      },
                      controller: startInput,
                      onTap: pickStartTime,
                      hintText: "Start Time",
                      fontSize: 15.0,
                    ),
                    const SizedBox(height: 20.0),
                    DefaultTextFormField(
                      onSaved: (newVal) {
                        _entime = newVal!;
                      },
                      validator: (String? value) {
                        if (value!.isEmpty) return "End Time is required";
                        return null;
                      },
                      controller: endInput,
                      onTap: pickEndTime,
                      hintText: "End Time",
                      fontSize: 15.0,
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: DefaultButton(
                          onPressed: () {
                            submit();
                          },
                          text: "SUBMIT",
                          textSize: 18.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
