import 'dart:convert';

import 'package:attendance/components/defaultText.dart';
import 'package:attendance/models/loginResponse.dart';
import 'package:attendance/models/studentDetailsResponse.dart';
import 'package:attendance/models/userResponse.dart';
import 'package:attendance/services/remoteServices.dart';
import 'package:attendance/utils/constants.dart';
import 'package:attendance/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _form = GlobalKey<FormState>();
  late String _username;
  late String _password;
  bool _isLoading = false;

  Future _getUser(token) async {
    UserResponse? user = await RemoteService().getUser(context);
    if (user != null) {
      return user;
    }
  }

  // getProfile() async {
  //   List<StudentDetails>? stdDetail = await RemoteService.stdDetails(context);
  //   var box = await Hive.openBox('userToken');

  //   if (stdDetail != null && stdDetail.isNotEmpty) {
  //     var picEncode = base64Encode(stdDetail[0].profilePicMemory);
  //     await box.put('profile', [
  //       stdDetail[0].userId.firstName,
  //       stdDetail[0].userId.lastName,
  //     ]);
  //   }
  // }

  void _login() async {
    var isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    //if form is valid
    _form.currentState!.save();
    LoginResponse? loginResponse =
        await RemoteService().login(_username, _password);

    if (loginResponse != null) {
      if (loginResponse.key != null) {
        // print(loginResponse.key);

        var box = await Hive.openBox('userToken');
        await box.put('token', loginResponse.key);
        await box.put('username', _username);

        UserResponse? userToken = await _getUser(loginResponse.key);

        if (userToken != null) {
          if (userToken.user_type == 'student') {
            await box.put('usertype', 'student');
            Navigator.popAndPushNamed(context, '/studentNav');
          } else if (userToken.user_type == 'lecturer') {
            await box.put('usertype', 'lecturer');
            Navigator.popAndPushNamed(context, '/lecturerNav');
          } else if (userToken.user_type == 'admin') {
            print('Page still in construction');
          } else {
            print('Invalid User Type');
          }
        } else {
          print('User not Found');
        }
      }

      if (loginResponse.non_field_errors != null) {
        for (var element in loginResponse.non_field_errors!) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: DefaultText(
            size: 15.0,
            text: element,
          )));
        }
      }
    }

    // print('Successfully Logged in');
    // Navigator.popAndPushNamed(context, "/lecturerNav");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFc5e5FF),
      body: SafeArea(
        child: Stack(
          children: [
            CustomPaint(
              size: Size(size.width, size.height),
              painter: PgPaint(),
            ),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xFF999999),
                                offset: Offset(0, 0),
                                blurRadius: 10.0,
                                spreadRadius: 5.0,
                              )
                            ],
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            border: Border.all(
                                color: Colors.white,
                                width: 4.0,
                                style: BorderStyle.solid),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Login',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Username is required";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _username = value!;
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  labelText: 'Username/Email',
                                ),
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Password is required";
                                  }

                                  return null;
                                },
                                onSaved: (newValue) {
                                  _password = newValue!;
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.lock),
                                  labelText: "Password",
                                ),
                              ),
                              const SizedBox(height: 24.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {},
                                    child: const DefaultText(
                                      text: 'Forgot Password?',
                                      size: 15.0,
                                      weight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        SizedBox(
                          width: size.width / 2,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(15.0)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              setState() {
                                _isLoading = true;
                                const CircularProgressIndicator();
                              }

                              _login();
                            },
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : const DefaultText(
                                    text: 'LOGIN',
                                    size: 18.0,
                                    weight: FontWeight.bold,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const DefaultText(
                              size: 15.0,
                              text: "Don't have an account? ",
                              weight: FontWeight.normal,
                            ),
                            GestureDetector(
                              onTap: () {
                                print('Tapped');
                              },
                              child: Text(
                                'Contact Admin',
                                style: TextStyle(
                                  color: Constants.primaryColor,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PgPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, size.height);
    path.lineTo(size.width, 100);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
