// To parse this JSON data, do
//
//     final attendance = attendanceFromJson(jsonString);

import 'dart:convert';

Attendance attendanceFromJson(String str) => Attendance.fromJson(json.decode(str));
List<Attendance> attendanceListFromJson(String str) => List<Attendance>.from(json.decode(str).map((x) => Attendance.fromJson(x)));

String attendanceToJson(Attendance data) => json.encode(data.toJson());

class Attendance {
    Attendance({
        required this.slotId,
    });

    SlotId slotId;

    factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        slotId: SlotId.fromJson(json["slot_id"]),
    );

    Map<String, dynamic> toJson() => {
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
