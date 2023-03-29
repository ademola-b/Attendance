import 'package:attendance/components/face_auth/camera_page.dart';
import 'package:attendance/components/face_auth/mark_attendance.dart';
import 'package:attendance/locator.dart';
import 'package:attendance/screens/general/login.dart';
import 'package:attendance/screens/general/onboard.dart';
import 'package:attendance/screens/lecturer/dashboard.dart';
import 'package:attendance/screens/lecturer/bottomNavBar.dart';
import 'package:attendance/screens/lecturer/initiate_attendance.dart';
import 'package:attendance/screens/lecturer/more.dart';
import 'package:attendance/screens/lecturer/performance.dart';
import 'package:attendance/screens/lecturer/reports.dart';
import 'package:attendance/screens/student/dashboard.dart';
import 'package:attendance/screens/student/mark_attendance.dart';
import 'package:attendance/utils/local_db.dart';
import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/student/bottomNavBar.dart';
import 'utils/constants.dart';

// void main() {
//   runApp(MyApp());
// }

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServices();
  await Hive.initFlutter();
  await HiveBoxes.initialize();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Constants.primaryColor),
      initialRoute: "/",
      onGenerateRoute: _onGenerateRoute,
    );
  }
}

Route<dynamic> _onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case "/":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const HomePage();
      });

    case "/login":
      return MaterialPageRoute(builder: (context) {
        return const Login();
      });

    case "/lecturerNav":
      return MaterialPageRoute(builder: (context) {
        return const LecturerNav();
      });

    case "/dashboard":
      return MaterialPageRoute(builder: (context) {
        return const LecturerDashboard();
      });

    case "/studentNav":
      return MaterialPageRoute(builder: (context) {
        return const StudentNav();
      });

    case "/registerFace":
      return MaterialPageRoute(builder: (context) {
        return const FaceScanScreen(); //to
      });

    case "/markAttendance":
      return MaterialPageRoute(builder: (context) {
        return const MarkAttendance(); //go to attendance page
      });

    case "/markAttendanceFace":
      return MaterialPageRoute(settings: settings, builder: (context) {
        return MarkAttendanceFace(settings.arguments); //to mark attendance
      });

    case "/initiate_attendance":
      return MaterialPageRoute(builder: (context) {
        return const InitiateAttendance();
      });

    case "/performance":
      return MaterialPageRoute(builder: (context) {
        return const Performance();
      });

    case "/reports":
      return MaterialPageRoute(builder: (context) {
        return const Reports();
      });

    case "/more":
      return MaterialPageRoute(builder: (context) {
        return const More();
      });

    default:
      return MaterialPageRoute(builder: (BuildContext context) {
        return const HomePage();
      });
  }
}
