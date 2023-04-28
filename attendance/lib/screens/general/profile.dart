import 'package:attendance/components/defaultButton.dart';
import 'package:attendance/components/defaultText.dart';
import 'package:attendance/components/defaultTextFormField.dart';
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
  TextEditingController? nameController;
  TextEditingController? emailController;
  TextEditingController? phoneController;
  TextEditingController? deptController;

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
                Column(
                  children: [
                    ClipOval(
                        child: Image.asset("assets/images/avatar.jpg",
                            width: 170, height: 170, fit: BoxFit.cover)),
                    DefaultText(
                      size: 25.0,
                      text: "Registration Number",
                      color: Constants.primaryColor,
                    )
                  ],
                ),
                const SizedBox(height: 20.0),
                Form(
                  child: Column(
                    children: [
                      DefaultTextFormField(
                        controller: nameController,
                        fontSize: 18.0,
                        hintText: 'Full Name',
                        enabled: false,
                      ),
                      const SizedBox(height: 20.0),
                      DefaultTextFormField(
                        controller: nameController,
                        fontSize: 18.0,
                        hintText: 'Email Address',
                        enabled: false,
                      ),
                      const SizedBox(height: 20.0),
                      DefaultTextFormField(
                        controller: nameController,
                        fontSize: 18.0,
                        hintText: 'Courses',
                        enabled: false,
                        maxLines: 10,
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
