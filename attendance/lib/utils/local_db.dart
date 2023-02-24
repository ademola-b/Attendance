import 'package:attendance/models/userFace.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveBoxes {
  static const userDetails = "user_details";

  static Box userDetailsBox() => Hive.box(userDetails);

  static initialize() async {
    await Hive.openBox(userDetails);
  }

  //when user logs out
  static clearAllBox() async {
    await HiveBoxes.userDetailsBox().clear();
  }
}

class LocalDB {
  //get the details of user - name and array.
  static UserFace getUser() =>
      UserFace.fromJson(HiveBoxes.userDetailsBox().toMap());

  //get only the name
  static String getUserName() =>
      HiveBoxes.userDetailsBox().toMap()[UserFace.nameKey];

  //get only the face array
  static String getUserArrayFace() =>
      HiveBoxes.userDetailsBox().toMap()[UserFace.arrayKey];

  //save user enteries
  static setUserDetails(UserFace userFace) =>
      HiveBoxes.userDetailsBox().putAll(userFace.toJson());
}
