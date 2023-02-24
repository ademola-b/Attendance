// To parse this JSON data, do
//
//     final attendanceSlotCreationResponse = attendanceSlotCreationResponseFromJson(jsonString);

import 'dart:convert';

AttendanceSlotCreationResponse attendanceSlotCreationResponseFromJson(String str) => AttendanceSlotCreationResponse.fromJson(json.decode(str));

String attendanceSlotCreationResponseToJson(AttendanceSlotCreationResponse data) => json.encode(data.toJson());

class AttendanceSlotCreationResponse {
    AttendanceSlotCreationResponse({
        required this.date,
        required this.startTime,
        required this.endTime,
        required this.longitude,
        required this.latitude,
        required this.radius,
        required this.status,
        required this.departmentId,
        required this.courseId,
    });

    DateTime date;
    String startTime;
    String endTime;
    String longitude;
    String latitude;
    String radius;
    String status;
    int departmentId;
    int courseId;

    factory AttendanceSlotCreationResponse.fromJson(Map<String, dynamic> json) => AttendanceSlotCreationResponse(
        date: DateTime.parse(json["date"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        radius: json["radius"],
        status: json["status"],
        departmentId: json["department_id"],
        courseId: json["course_id"],
    );

    Map<String, dynamic> toJson() => {
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "start_time": startTime,
        "end_time": endTime,
        "longitude": longitude,
        "latitude": latitude,
        "radius": radius,
        "status": status,
        "department_id": departmentId,
        "course_id": courseId,
    };
}
