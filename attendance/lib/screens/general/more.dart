import 'dart:convert';

import 'package:attendance/components/defaultButton.dart';
import 'package:attendance/components/defaultText.dart';
import 'package:attendance/models/lecturers_response.dart';
import 'package:attendance/models/studentDetails.dart';
import 'package:attendance/models/studentDetailsResponse.dart';
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
  String? userType;
  List stdCourse = [];
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

  final List<String> _labelRoutes = ['/profile', '/changePassword', '/about'];

   _getUserType() async {
    var box = await Hive.openBox('userToken');
    String user_type = box.get('usertype');
    setState(() {
      userType = user_type;
    });
    print("usertype update: {$userType}");
  }

  @override
  void initState() {
    _getUserType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const DefaultText(text: 'PROFILE', size: 22.0),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 50.0, right: 20.0, left: 20.0),
          child: Column(
            children: [
              Center(
                child: userType == 'student'? FutureBuilder<List<StudentDetails>?>(
                  future: RemoteService.stdDetails(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data;
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
                                image: MemoryImage(data![0].profilePicMemory),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          DefaultText(
                              size: 20.0,
                              text:
                                  "${data[0].userId.firstName} ${data[0].userId.lastName}",
                              weight: FontWeight.bold),
                          DefaultText(
                              size: 18.0,
                              text: data[0].userId.username,
                              color: Colors.grey,
                              weight: FontWeight.bold),
                        ],
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ) : FutureBuilder<List<LectResponse>?>(
                  future: RemoteService.getLect(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data;
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
                                image: MemoryImage(base64Decode(data![0].picMem)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          DefaultText(
                              size: 20.0,
                              text:
                                  "${data[0].userId.firstName} ${data[0].userId.lastName}",
                              weight: FontWeight.bold),
                          DefaultText(
                              size: 18.0,
                              text: data[0].userId.username,
                              color: Colors.grey,
                              weight: FontWeight.bold),
                        ],
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ) ,
              const SizedBox(height: 40.0),
              Expanded(
                child: ListView.builder(
                    itemCount: _labels.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Constants.primaryColor, width: 0.2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: ListTile(
                          textColor: Constants.primaryColor,
                          leading: Icon(
                            _labelIcons[index],
                            color: Constants.primaryColor,
                          ),
                          title: DefaultText(
                            text: _labels[index],
                            size: 16.0,
                            color: Colors.black,
                          ),
                          trailing: const Icon(
                            FontAwesomeIcons.angleRight,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, _labelRoutes[index]);
                          },
                        ),
                      );
                    }),
              ),
              Container(
                margin: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.red),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
                child: ListTile(
                  textColor: Colors.red,
                  leading: const Icon(FontAwesomeIcons.doorOpen),
                  title: const DefaultText(size: 15.0, text: "Logout"),
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
        ),
      ),
    );
  }
}
