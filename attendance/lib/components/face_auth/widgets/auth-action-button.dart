import 'dart:async';

import 'package:attendance/components/defaultText.dart';
import 'package:attendance/locator.dart';
import 'package:attendance/models/studentFace.dart';
import 'package:attendance/models/userFace.dart';
import 'package:attendance/models/userResponse.dart';
import 'package:attendance/services/cameraService.dart';
import 'package:attendance/services/mlService.dart';
import 'package:attendance/services/remoteServices.dart';
import 'package:attendance/utils/constants.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class AuthActionButton extends StatefulWidget {
  final Function onPressed;
  final bool isLogin;
  final Function reload;

  const AuthActionButton(
      {Key? key,
      required this.onPressed,
      required this.isLogin,
      required this.reload})
      : super(key: key);

  @override
  State<AuthActionButton> createState() => _AuthActionButtonState();
}

class _AuthActionButtonState extends State<AuthActionButton> {
  final MLService _mlService = locator<MLService>();
  final CameraService _cameraService = locator<CameraService>();

  Future<StudentFace?> _predictUser() async {
    // StudentFace? std = await _mlService.
  }

  Future onTap() async {
    try {
      bool faceDetected = await widget.onPressed();

      if (faceDetected) {
        if (widget.isLogin) {}
        await _registerFace();
      }
    } catch (e) {
      print("from action-try - $e");
    }
  }

  Future _registerFace() async {
    List predictedData = _mlService.predictedData;
    print(predictedData);

    List flat = predictedData.expand((e) => e).toList();

    print(flat);

    await RemoteService().registStudentFace(flat);
    
    _mlService.setPredictedData([]);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Constants.primaryColor,
          ),
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 15),
          width: MediaQuery.of(context).size.width * 0.8,
          height: 60,
          child: Center(
              child: DefaultText(
            size: 18,
            text: 'CAPTURE',
            color: Colors.white,
            weight: FontWeight.bold,
          ))),
    );
  }
}
