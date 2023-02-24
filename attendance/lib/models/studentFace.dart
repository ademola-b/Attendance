import 'dart:convert';

List<StudentFace?>? studentFaceFromJson(String str) => json.decode(str) == null ? [] : List<StudentFace?>.from(json.decode(str)!.map((x) => StudentFace.fromJson(x)));

String studentFaceToJson(List<StudentFace?>? data) => json.encode(data == null ? [] : List<dynamic>.from(data!.map((x) => x!.toJson())));

class StudentFace {
    StudentFace({
        this.studentFace,
    });

    List<double?>? studentFace;

    factory StudentFace.fromJson(Map<String, dynamic> json) => StudentFace(
        studentFace: json["student_face"] == null ? [] : List<double?>.from(json["student_face"]!.map((x) => x.toDouble())),
    );

    Map<String, dynamic> toJson() => {
        "student_face": studentFace == null ? [] : List<dynamic>.from(studentFace!.map((x) => x)),
    };
}
