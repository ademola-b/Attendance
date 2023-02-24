import 'package:attendance/models/studentDetails.dart';
import 'package:attendance/models/userResponse.dart';
import 'package:attendance/services/remoteServices.dart';
import 'package:attendance/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

class More extends StatefulWidget {
  const More({Key? key}) : super(key: key);

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  String? _username = 'Loading...';
  String? _first = 'FirstName', _last = 'LastName';
  List stdCourse = [];

  late Future<StudentDetails?> futureStudentDetail;

  StudentDetails? stdDetail;
  UserResponse? user;

  var profile_pic;

  final List<String> _labels = [
    "Personal Information",
    "Change password",
    "About Application",
  ];

  final List<IconData> _labelIcons = [
    FontAwesomeIcons.person,
    FontAwesomeIcons.lock,
    FontAwesomeIcons.addressBook,
  ];

  Future<UserResponse?> _getUser() async {
    UserResponse? user = await RemoteService().getUser(context);
    if (user != null) {
      setState(() {
        _username = user.username;
      });

      return user;
    }
    return null;
  }

  Future<StudentDetails?> _getStudentDetail() async {
    UserResponse? user = await RemoteService().getUser(context);
    if (user != null) {
      stdDetail = await RemoteService().studentDetails(user.username, context);
      if (stdDetail != null) {
        setState(() {
          // profile_pic = stdDetail!.profile_pic_memory;
          // print(profile_pic);
        });

        // print('Not null');
        // _first = stdDetail!.userId.firstName;
        // _last = stdDetail!.userId.lastName;

        // stdCourse = [...stdCourse, ...stdDetail!.courseTitle];
        // print(stdCourse);
        return stdDetail;
      }
      return null;
    }
    return null;
  }

  @override
  void initState() {
    futureStudentDetail = _getStudentDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              const SizedBox(
                height: 220.0,
                child: Image(
                  image: AssetImage('assets/images/cool_bg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: -110,
                child: Center(
                  child: FutureBuilder<StudentDetails?>(
                    future: futureStudentDetail,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            Container(
                              height: 150.0,
                              width: 150.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.0),
                                border:
                                    Border.all(color: Colors.white, width: 4.0),
                                image: DecorationImage(
                                  image: MemoryImage(
                                      snapshot.data!.profile_pic_memory),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        "${snapshot.data!.userId.firstName} ${snapshot.data!.userId.lastName} \n",
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                  TextSpan(
                                    text: snapshot.data!.userId.username,
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 17),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.builder(
                  padding: const EdgeInsets.only(top: 120.0),
                  itemCount: _labels.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: ListTile(
                        leading: Icon(_labelIcons[index]),
                        title: Text(_labels[index]),
                        trailing: const Icon(FontAwesomeIcons.angleRight),
                        onTap: () {},
                      ),
                    );
                  }),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.red),
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            child: ListTile(
              textColor: Colors.red,
              leading: Icon(FontAwesomeIcons.doorOpen),
              title: Text("Logout"),
              trailing: const Icon(FontAwesomeIcons.angleRight),
              onTap: () async {
                var box = await Hive.box('userToken');
                box.deleteAll(['token', 'username']);
                Navigator.popAndPushNamed(context, '/login');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MorePaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Constants.primaryColor
      ..style = PaintingStyle.fill;

    // Path path = Path()..moveTo(0, 0);

    // path.arcToPoint(Offset(size.width, 100),
    //     radius: Radius.circular(1.0), clockwise: false, largeArc: true);

    // canvas.drawPath(path, paint);

    canvas.drawArc(Offset(100, 100) & Size(100, 100), 0, 2, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
