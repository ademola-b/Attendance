import 'package:hive_flutter/hive_flutter.dart';

// String base_url = 'http://192.168.43.182:42845';
// String base_url = 'http://192.168.43.130:32875';
// String base_url = 'http://192.168.199.182:8000';
String base_url = 'http://192.168.43.182:35835';

//login url
Uri loginUrl = Uri.parse("$base_url/accounts/login/");

//user_url
Uri userUrl = Uri.parse("$base_url/accounts/user/");

//studentFace_url
Uri studentFaceUrl = Uri.parse("$base_url/students/face/student-face/");

//student_details url
late String username;
Uri studentDetailsUrl = Uri.parse("$base_url/students/$username/");

//attendance_slot url
Uri attendanceSlotUrl = Uri.parse("$base_url/attendance/slots/");

//attendance_slot url
Uri markAttendanceUrl = Uri.parse("$base_url/attendance/");

//get username
_getUsername() async {
  var box = await Hive.openBox('usertoken');
  String user = box.get('username');
  return user;
}

//student_course url
Uri studentCourseUrl = Uri.parse("$base_url/students/course/$username/");

//departments
Uri deptUrl = Uri.parse("$base_url/students/departments/all/");

//lecturers
Uri lectUrl = Uri.parse("$base_url/lecturers/");

//attendance slot creation url
Uri slotCreUrl = Uri.parse("$base_url/attendance/attendance-slot/create/");
