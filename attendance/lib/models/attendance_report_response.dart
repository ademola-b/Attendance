// To parse this JSON data, do
//
//     final attendanceReport = attendanceReportFromJson(jsonString);

import 'dart:convert';

List<AttendanceReport> attendanceReportFromJson(String str) => List<AttendanceReport>.from(json.decode(str).map((x) => AttendanceReport.fromJson(x)));

String attendanceReportToJson(List<AttendanceReport> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AttendanceReport {
    AttendanceReport({
        required this.id,
        required this.studentId,
        required this.slotId,
    });

    int id;
    StudentId studentId;
    SlotId slotId;

    factory AttendanceReport.fromJson(Map<String, dynamic> json) => AttendanceReport(
        id: json["id"],
        studentId: StudentId.fromJson(json["student_id"]),
        slotId: SlotId.fromJson(json["slot_id"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "student_id": studentId.toJson(),
        "slot_id": slotId.toJson(),
    };
}

class SlotId {
    SlotId({
        required this.id,
        required this.courseId,
        required this.date,
    });

    int id;
    String courseId;
    DateTime date;

    factory SlotId.fromJson(Map<String, dynamic> json) => SlotId(
        id: json["id"],
        courseId: json["course_id"],
        date: DateTime.parse(json["date"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    };
}

class StudentId {
    StudentId({
        required this.userId,
    });

    UserId userId;

    factory StudentId.fromJson(Map<String, dynamic> json) => StudentId(
        userId: UserId.fromJson(json["user_id"]),
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId.toJson(),
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
