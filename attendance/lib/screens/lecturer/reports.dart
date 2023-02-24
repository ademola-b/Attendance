import 'package:attendance/components/defaultButton.dart';
import 'package:attendance/components/defaultText.dart';
import 'package:attendance/screens/lecturer/report_form.dart';
import 'package:attendance/screens/student/mark_attendance.dart';
import 'package:attendance/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Reports extends StatefulWidget {
  const Reports({Key? key}) : super(key: key);

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: CustomPaint(
                size: Size(size.width, 500),
                painter: MarkAttendancePaint(),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 80.0, left: 30.0, right: 30.0, bottom: 10.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DefaultText(
                      size: 25.0,
                      text: "Reports",
                      color: Constants.primaryColor,
                    ),
                    const SizedBox(height: 50.0),
                    const DefaultText(
                      size: 25.0,
                      text: 'No report generated yet',
                    ),
                    const DefaultText(
                      size: 20,
                      text: 'Generate your first report',
                      color: Colors.grey,
                    ),
                    const Spacer(),
                    SizedBox(
                        width: size.width,
                        child: DefaultButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ReportForm()));
                            },
                            text: 'Generate New Report',
                            textSize: 18))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
