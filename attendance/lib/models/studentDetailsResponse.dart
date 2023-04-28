// To parse this JSON data, do
//
//     final studentDetails = studentDetailsFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/foundation.dart';

List<StudentDetails> studentDetailsFromJson(String str) => List<StudentDetails>.from(json.decode(str).map((x) => StudentDetails.fromJson(x)));

String studentDetailsToJson(List<StudentDetails> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StudentDetails {
    UserId userId;
    String profilePic;
    String departmentId;
    String level;
    List<String> courses;
    Uint8List profilePicMemory;

    StudentDetails({
        required this.userId,
        required this.profilePic,
        required this.departmentId,
        required this.level,
        required this.courses,
        required this.profilePicMemory,
    });

    factory StudentDetails.fromJson(Map<String, dynamic> json) => StudentDetails(
        userId: UserId.fromJson(json["user_id"]),
        profilePic: json["profile_pic"],
        departmentId: json["department_id"],
        level: json["level"],
        courses: List<String>.from(json["courses"].map((x) => x)),
        profilePicMemory: base64Decode(json["profile_pic_memory"]),
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId.toJson(),
        "profile_pic": profilePic,
        "department_id": departmentId,
        "level": level,
        "courses": List<dynamic>.from(courses.map((x) => x)),
        "profile_pic_memory": profilePicMemory,
    };
}

class UserId {
    int id;
    String username;
    String firstName;
    String lastName;
    String email;

    UserId({
        required this.id,
        required this.username,
        required this.firstName,
        required this.lastName,
        required this.email,
    });

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
