// To parse this JSON data, do
//
//     final courses = coursesFromJson(jsonString);

import 'dart:convert';

Courses coursesFromJson(String str) => Courses.fromJson(json.decode(str));

String coursesToJson(Courses data) => json.encode(data.toJson());

class Courses {
    Courses({
        required this.courses,
    });

    List<String> courses;

    factory Courses.fromJson(Map<String, dynamic> json) => Courses(
        courses: List<String>.from(json["courses"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "courses": List<dynamic>.from(courses.map((x) => x)),
    };
}
