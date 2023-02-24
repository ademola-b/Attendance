// To parse this JSON data, do
//
//     final deptResponse = deptResponseFromJson(jsonString);

import 'dart:convert';

List<DeptResponse> deptResponseFromJson(String str) => List<DeptResponse>.from(json.decode(str).map((x) => DeptResponse.fromJson(x)));

String deptResponseToJson(List<DeptResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DeptResponse {
    DeptResponse({
        required this.id,
        required this.deptName,
    });

    int id;
    String deptName;

    factory DeptResponse.fromJson(Map<String, dynamic> json) => DeptResponse(
        id: json["id"],
        deptName: json["deptName"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "deptName": deptName,
    };
}
