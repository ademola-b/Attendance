// To parse this JSON data, do
//
//     final attendanceSlot = attendanceSlotFromJson(jsonString);

import 'dart:convert';

List<AttendanceSlot> attendanceSlotFromJson(String str) => List<AttendanceSlot>.from(json.decode(str).map((x) => AttendanceSlot.fromJson(x)));

String attendanceSlotToJson(List<AttendanceSlot> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AttendanceSlot {
    AttendanceSlot({
        required this.id,
        required this.courseId,
        required this.departmentId,
        required this.lecturerId,
        required this.date,
        required this.startTime,
        required this.endTime,
        required this.longitude,
        required this.latitude,
        required this.radius,
    });

    int id;
    String courseId;
    String departmentId;
    String lecturerId;
    DateTime date;
    String startTime;
    String endTime;
    String longitude;
    String latitude;
    String radius;

    factory AttendanceSlot.fromJson(Map<String, dynamic> json) => AttendanceSlot(
        id: json["id"],
        courseId: json["course_id"],
        departmentId: json["department_id"],
        lecturerId: json["lecturer_id"],
        date: DateTime.parse(json["date"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        radius: json["radius"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "department_id": departmentId,
        "lecturer_id": lecturerId,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "start_time": startTime,
        "end_time": endTime,
        "longitude": longitude,
        "latitude": latitude,
        "radius": radius,
    };
}
