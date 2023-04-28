import 'dart:convert';

import 'package:attendance/components/defaultButton.dart';
import 'package:attendance/components/defaultText.dart';
import 'package:attendance/components/defaultTextFormField.dart';
import 'package:attendance/models/lecturers_response.dart';
import 'package:attendance/models/studentDetailsResponse.dart';
import 'package:attendance/services/remoteServices.dart';
import 'package:attendance/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? userType;

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
    // TODO: implement initState
    _getUserType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(
              top: 30.0, left: 20.0, right: 20.0, bottom: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: (() => Navigator.pop(context)),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Constants.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                const SizedBox(height: 20.0),
                userType == 'student'
                    ? FutureBuilder<List<StudentDetails>?>(
                        future: RemoteService.stdDetails(context),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var data = snapshot.data![0];

                            return Column(
                              children: [
                                data.profilePicMemory == ''
                                    ? ClipOval(
                                        child: Image.asset(
                                            "assets/images/avatar.jpg",
                                            width: 170,
                                            height: 170,
                                            fit: BoxFit.cover))
                                    : ClipOval(
                                        child: Image.memory(
                                            data.profilePicMemory,
                                            width: 170,
                                            height: 170,
                                            fit: BoxFit.cover)),
                                DefaultText(
                                  size: 25.0,
                                  text: data.userId.username,
                                  color: Constants.primaryColor,
                                ),
                                const SizedBox(height: 20.0),
                                DefaultTextFormField(
                                  fontSize: 18.0,
                                  hintText:
                                      "${data.userId.firstName} ${data.userId.lastName}",
                                  enabled: false,
                                ),
                                const SizedBox(height: 20.0),
                                DefaultTextFormField(
                                  fontSize: 18.0,
                                  hintText: data.userId.email,
                                  enabled: false,
                                ),
                                const SizedBox(height: 20.0),
                                DefaultTextFormField(
                                  fontSize: 18.0,
                                  hintText: data.level,
                                  enabled: false,
                                ),
                                const SizedBox(height: 20.0),
                                DefaultTextFormField(
                                  fontSize: 18.0,
                                  hintText: data.courses[0],
                                  enabled: false,
                                  maxLines: 10,
                                ),
                                const SizedBox(height: 20.0),
                              ],
                            );
                          }

                          return const CircularProgressIndicator();
                        })
                    : FutureBuilder<List<LectResponse>?>(
                        future: RemoteService.getLect(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var data = snapshot.data![0];
                            return Column(
                              children: [
                                data.picMem == ''
                                    ? ClipOval(
                                        child: Image.asset(
                                            "assets/images/avatar.jpg",
                                            width: 170,
                                            height: 170,
                                            fit: BoxFit.cover))
                                    : ClipOval(
                                        child: Image.memory(
                                            base64Decode(data.picMem),
                                            width: 170,
                                            height: 170,
                                            fit: BoxFit.cover)),
                                DefaultText(
                                  size: 25.0,
                                  text: data.userId.username,
                                  color: Constants.primaryColor,
                                ),
                                const SizedBox(height: 20.0),
                                DefaultTextFormField(
                                  fontSize: 18.0,
                                  hintText:
                                      "${data.userId.firstName} ${data.userId.lastName}",
                                  enabled: false,
                                ),
                                const SizedBox(height: 20.0),
                                DefaultTextFormField(
                                  fontSize: 18.0,
                                  hintText: data.userId.email,
                                  enabled: false,
                                ),
                                const SizedBox(height: 20.0),
                                DefaultTextFormField(
                                  fontSize: 18.0,
                                  hintText: data.level,
                                  enabled: false,
                                ),
                                const SizedBox(height: 20.0),
                                DefaultTextFormField(
                                  fontSize: 18.0,
                                  hintText:
                                      "${data.courseId.courseCode} - ${data.courseId.courseTitle}",
                                  enabled: false,
                                ),
                              ],
                            );
                          }

                          return const CircularProgressIndicator();
                        })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
