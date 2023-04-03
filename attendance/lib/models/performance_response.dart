// To parse this JSON data, do
//
//     final performance = performanceFromJson(jsonString);

import 'dart:convert';

List<Performance> performanceFromJson(String str) => List<Performance>.from(
    json.decode(str).map((x) => Performance.fromJson(x)));

String performanceToJson(List<Performance> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Performance {
  Performance({
    required this.id,
    required this.student,
    required this.course,
    required this.performancePercent,
  });

  int id;
  int student;
  String course;
  double performancePercent;

  factory Performance.fromJson(Map<String, dynamic> json) => Performance(
        id: json["id"],
        student: json["student"],
        course: json["course"],
        performancePercent: json["performance_percent"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "student": student,
        "course": course,
        "performance_percent": performancePercent,
      };
}
