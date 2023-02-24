class UserFace {
  static const String nameKey = "username";
  static const String arrayKey = "userFace_array";

  String? name;
  List? array;

  //constructor class
  UserFace({this.name, this.array});

  factory UserFace.fromJson(Map<dynamic, dynamic> json) {
    return UserFace(
      name: json[nameKey],
      array: json[arrayKey],
    );
  }

  Map<String, dynamic> toJson() => {
    nameKey: name,
    arrayKey: array,
  };
}
