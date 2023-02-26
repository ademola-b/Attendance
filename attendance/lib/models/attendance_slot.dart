// To parse this JSON data, do
//
//     final attendanceSlotResponse = attendanceSlotResponseFromJson(jsonString);

import 'dart:convert';

List<AttendanceSlotResponse> attendanceSlotResponseFromJson(String str) => List<AttendanceSlotResponse>.from(json.decode(str).map((x) => AttendanceSlotResponse.fromJson(x)));

String attendanceSlotResponseToJson(List<AttendanceSlotResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AttendanceSlotResponse {
    AttendanceSlotResponse({
        required this.id,
        required this.departmentId,
        required this.lecturerId,
        required this.courseId,
        required this.date,
        required this.startTime,
        required this.endTime,
        required this.longitude,
        required this.latitude,
        required this.radius,
        required this.status,
    });

    int id;
    DepartmentId departmentId;
    String lecturerId;
    CourseId courseId;
    DateTime date;
    String startTime;
    String endTime;
    String longitude;
    String latitude;
    String radius;
    String status;

    factory AttendanceSlotResponse.fromJson(Map<String, dynamic> json) => AttendanceSlotResponse(
        id: json["id"],
        departmentId: DepartmentId.fromJson(json["department_id"]),
        lecturerId: json["lecturer_id"],
        courseId: CourseId.fromJson(json["course_id"]),
        date: DateTime.parse(json["date"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        radius: json["radius"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "department_id": departmentId.toJson(),
        "lecturer_id": lecturerId,
        "course_id": courseId.toJson(),
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "start_time": startTime,
        "end_time": endTime,
        "longitude": longitude,
        "latitude": latitude,
        "radius": radius,
        "status": status,
    };
}

class CourseId {
    CourseId({
        required this.id,
        required this.courseCode,
        required this.courseTitle,
    });

    int id;
    String courseCode;
    String courseTitle;

    factory CourseId.fromJson(Map<String, dynamic> json) => CourseId(
        id: json["id"],
        courseCode: json["course_code"],
        courseTitle: json["course_title"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "course_code": courseCode,
        "course_title": courseTitle,
    };
}

class DepartmentId {
    DepartmentId({
        required this.id,
        required this.deptName,
    });

    int id;
    String deptName;

    factory DepartmentId.fromJson(Map<String, dynamic> json) => DepartmentId(
        id: json["id"],
        deptName: json["deptName"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "deptName": deptName,
    };
}
