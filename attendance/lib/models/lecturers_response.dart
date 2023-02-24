// To parse this JSON data, do
//
//     final lectResponse = lectResponseFromJson(jsonString);

import 'dart:convert';

List<LectResponse> lectResponseFromJson(String str) => List<LectResponse>.from(json.decode(str).map((x) => LectResponse.fromJson(x)));

String lectResponseToJson(List<LectResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LectResponse {
    LectResponse({
        required this.id,
        this.profilePic,
        required this.picMem,
        required this.level,
        required this.userId,
        required this.departmentId,
        required this.courseId,
    });

    int id;
    String? profilePic;
    String picMem;
    String level;
    UserId userId;
    String departmentId;
    String courseId;

    factory LectResponse.fromJson(Map<String, dynamic> json) => LectResponse(
        id: json["id"],
        profilePic: json["profile_pic"],
        picMem: json["pic_mem"],
        level: json["level"],
        userId: UserId.fromJson(json["user_id"]),
        departmentId: json["department_id"],
        courseId: json["course_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "profile_pic": profilePic,
        "pic_mem": picMem,
        "level": level,
        "user_id": userId.toJson(),
        "department_id": departmentId,
        "course_id": courseId,
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
