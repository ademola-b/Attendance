import 'dart:convert';

import 'package:attendance/components/defaultText.dart';
import 'package:attendance/models/attendance_slot.dart';
import 'package:attendance/models/attendance_slot_creation_response.dart';
import 'package:attendance/models/departments_response.dart';
import 'package:attendance/models/lecturers_response.dart';
import 'package:attendance/models/loginResponse.dart';
import 'package:attendance/models/studentDetails.dart';
import 'package:attendance/models/studentFace.dart';
import 'package:attendance/models/userResponse.dart';
import 'package:attendance/services/urls.dart';
import 'package:attendance/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;

class RemoteService {
  //login
  Future<LoginResponse?> login(String username, String password) async {
    try {
      var data = await http.post(loginUrl, body: {
        'username': username,
        'password': password,
      });
      var response = data.body; //will be in json format
      return LoginResponse.fromJson(jsonDecode(response));
    } catch (e) {
      print('oops!, seems the server is down');
    }
    return null;
  }

  //get user
  Future<UserResponse?> getUser(context) async {
    //get user token
    var box = await Hive.openBox('userToken');
    String token = box.get('token');
    try {
      var response =
          await http.get(userUrl, headers: {"Authorization": "Token $token"});

      if (response.statusCode == 200) {
        print(response.body);
        return UserResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to get user detail');
      }
    } catch (e) {
      // showDialog(context: context, builder: builder)
      AlertDialog(
        content: const DefaultText(
          size: 15,
          text: "Server down, try again later",
          color: Colors.red,
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(14.0),
                child: const Text('Okay'),
              ))
        ],
      );
    }
  }

  //get student's face
  Future<List<StudentFace?>?> studentFace() async {
    var box = await Hive.openBox('userToken');
    String token = box.get('token');
    try {
      var response = await http
          .get(studentFaceUrl, headers: {'Authorization': "Token $token"});

      if (response.statusCode == 200) {
        final studentFace = studentFaceFromJson(response.body);

        return studentFace;
      } else {
        throw Exception('Failed to get student face');
      }
    } catch (e) {
      print('An error occured');
    }
    return null;
  }

  //save student face
  Future<StudentFace?> registStudentFace(List stdFace) async {
    var box = await Hive.openBox('userToken');
    String token = box.get('token');
    var body = jsonEncode({'student_face': stdFace.toList()});
    try {
      var response = await http.post(studentFaceUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': "Token $token"
          },
          body: body);

      print(response.body);

      if (response.statusCode == 201) {
        return StudentFace.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to register face');
      }
    } catch (e) {
      print(e);
      print('An error occurred saving face');
    }
  }

  //get student details
  Future<StudentDetails?> studentDetails(String username, context) async {
    try {
      var response = await http.get(Uri.parse("$base_url/students/$username/"));

      if (response.statusCode == 200) {
        var jsonResponse = response.body;
        final studentDetails = studentDetailsFromJson(jsonResponse);
        print(studentDetails.userId.username);
        return studentDetails;
      }
    } catch (e) {
      print(e);
      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("There's a problem with the server")));
    }

    return null;
  }

  Future<StudentCourse?> studentCourse(String username) async {
    var box = await Hive.openBox('userToken');
    String token = box.get('token');
    try {
      var response = await http.get(
          Uri.parse("$base_url/students/courses/$username/"),
          headers: {"Authorization": "Token $token"});
      if (response.statusCode == 200) {
        final studentCourse = studentCourseFromJson(response.body);
        return studentCourse;
      }
    } catch (e) {
      print('Server seems to be down');
    }
    return null;
  }

  //Attendance Slot
  Future<List<AttendanceSlotResponse>> attendanceSlot() async {
    //get user token
    var box = await Hive.openBox('usertoken');
    String token = box.get('token');
    try {
      var response = await http
          .get(attendanceSlotUrl, headers: {"Authorization": "Token $token"});

      if (response.statusCode == 200) {
        final slots = attendanceSlotResponseFromJson(response.body);
        return slots;
      } else {
        throw Exception("Failed to get Attendance Slot");
      }
    } catch (e) {
      print(e);
    }

    return <AttendanceSlotResponse>[];
  }

  //get department list
  Future<List<DeptResponse>> getDepartmentList() async {
    try {
      var response = await http.get(deptUrl);
      if (response.statusCode == 200) {
        final dept = deptResponseFromJson(response.body);
        return dept;
      } else {
        throw Exception("Failed to get departments list");
      }
    } catch (e) {
      print("An error occured: $e");
    }

    return <DeptResponse>[];
  }

//Get Lecturer
  Future<List<LectResponse>> getLect() async {
    var box = await Hive.openBox('usertoken');
    String token = box.get('token');
    var response =
        await http.get(lectUrl, headers: {"Authorization": "Token $token"});
    if (response.statusCode == 200) {
      final lect = lectResponseFromJson(response.body);
      return lect;
    } else {
      throw Exception("Failed to get lecturer");
    }
  }

//Slot Creation
  Future<AttendanceSlotCreationResponse?> slotCreation(
      {required DateTime date,
      required String startTime,
      required String endTime,
      required String longitude,
      required String latitude,
      required String radius,
      required String status,
      required int departmentId,
      required int courseId}) async {
    var box = await Hive.openBox('usertoken');
    String token = box.get('token');
    var data = jsonEncode({
      "date": date.toIso8601String(),
      "start_time": startTime,
      "end_time": endTime,
      "longitude": longitude,
      "latitude": latitude,
      "radius": radius,
      "status": status,
      "department_id": departmentId,
      "course_id": courseId
    });
    var response = await http.post(slotCreUrl, body: data, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Token $token"
    });
    try {
      if (response.statusCode == 201) {
        final slot = attendanceSlotCreationResponseFromJson(response.body);
        return slot;
      } else {
        throw Exception("Failed to create slot");
      }
    } catch (e) {
      print("An error occurred while initializing slot: $e");
    }
  }
}
