// To parse this JSON data, do
//
//     final studentDetails = studentDetailsFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/foundation.dart';

StudentDetails studentDetailsFromJson(String str) =>
    StudentDetails.fromJson(json.decode(str));

String studentDetailsToJson(StudentDetails data) => json.encode(data.toJson());

class StudentDetails {
  StudentDetails({
    required this.userId,
    required this.profilePic,
    required this.departmentId,
    required this.level,
    required this.courseTitle,
    required this.profile_pic_memory
  });

  UserId userId;
  String profilePic;
  String departmentId;
  String level;
  List<String> courseTitle;
  Uint8List profile_pic_memory;

  factory StudentDetails.fromJson(Map<String, dynamic> json) => StudentDetails(
        userId: UserId.fromJson(json["user_id"]),
        profilePic: json["profile_pic"],
        departmentId: json["department_id"],
        level: json["level"],
        courseTitle: List<String>.from(json["course_title"].map((x) => x)),
        profile_pic_memory: base64Decode(json["profile_pic_memory"])

      );

  Map<String, dynamic> toJson() => {
        "user_id": userId.toJson(),
        "profile_pic": profilePic,
        "department_id": departmentId,
        "level": level,
        "course_title": List<dynamic>.from(courseTitle.map((x) => x)),
      };
}

class UserId {
  UserId({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  int id;
  String username;
  String firstName;
  String lastName;
  String email;

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json["id"],
        username: json["username"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
      };
}

//student course
StudentCourse studentCourseFromJson(String str) => StudentCourse.fromJson(json.decode(str));

String studentCourseToJson(StudentCourse data) => json.encode(data.toJson());

class StudentCourse {
    StudentCourse({
        required this.courseTitle,
    });

    List<String> courseTitle;

    factory StudentCourse.fromJson(Map<String, dynamic> json) => StudentCourse(
        courseTitle: List<String>.from(json["course_title"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "course_title": List<dynamic>.from(courseTitle.map((x) => x)),
    };
}
