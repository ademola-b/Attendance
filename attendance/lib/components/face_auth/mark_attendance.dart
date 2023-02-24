import 'package:attendance/components/defaultText.dart';
import 'package:attendance/components/face_auth/widgets/face_painter.dart';
import 'package:attendance/components/face_auth/widgets/mark_attendance_plugs.dart';
import 'package:attendance/components/face_auth/widgets/single_picture.dart';
import 'package:attendance/locator.dart';
import 'package:attendance/models/studentFace.dart';
import 'package:attendance/services/cameraService.dart';
import 'package:attendance/services/faceDetectorService.dart';
import 'package:attendance/services/mlService.dart';
import 'package:attendance/utils/constants.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

// import 'dart:math' as math;

class MarkAttendanceFace extends StatefulWidget {
  const MarkAttendanceFace({Key? key}) : super(key: key);

  @override
  State<MarkAttendanceFace> createState() => _MarkAttendanceFaceState();
}

class _MarkAttendanceFaceState extends State<MarkAttendanceFace> {
  CameraService _cameraService = locator<CameraService>();
  FaceDetectorService _faceDetectorService = locator<FaceDetectorService>();
  MLService _mlService = locator<MLService>();

  bool _isInitializing = false;
  bool _isPictureTaken = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _faceDetectorService.dispose();
    super.dispose();
  }

  Future _start() async {
    setState(() {
      _isInitializing = true;
    });
    //start camera
    await _cameraService.initialize();
    setState(() {
      _isInitializing = false;
    });

    _frameFaces();
  }

  _frameFaces() {
    bool processing = false;
    _cameraService.cameraController!
        .startImageStream((CameraImage image) async {
      if (processing) return;
      processing = true;
      await _predictFacesFromImage(image: image);
      processing = false;
    });
  }

  Future<void> _predictFacesFromImage({@required CameraImage? image}) async {
    assert(image != null,
        'Image is not found'); //don't do anything if condition returns true
    await _faceDetectorService.detectFacesFromImage(
        image!); //wait till face is detected from the image
    if (_faceDetectorService.faceDetected) {
      _mlService.setCurrentPrediction(image, _faceDetectorService.faces[0]);
    }

    if (mounted) setState(() {});
  }

  Future<void> takePicture() async {
    if (_faceDetectorService.faceDetected) {
      await _cameraService
          .takePicture(); //snap picture and return the file where it is stored
      setState(() => _isPictureTaken = true);
    } else {
      showDialog(
          context: context,
          builder: ((context) => AlertDialog(
                content: const Text('Face is not detected!'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Recapture")),
                ],
              )));
    }
  }

  Future<void> onTap() async {
    await takePicture();
    if (_faceDetectorService.faceDetected) {
      StudentFace? stdFace = await _mlService.predict();
      if (stdFace != null) {
        showDialog(
            context: context,
            builder: (builder) => const AlertDialog(
                  content: DefaultText(
                    size: 18,
                    text: 'Attendance Marked',
                    color: Colors.green,
                  ),
                  actions: [],
                ));
      } else {
        showDialog(
            context: context,
            builder: (builder) => const AlertDialog(
                  content: DefaultText(
                    size: 18,
                    text: 'Unrecognized Face!',
                    color: Colors.red,
                    weight: FontWeight.bold,
                  ),
                ));
      }
    }
  }

  Widget getBodyWidget() {
    if (_isInitializing) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_isPictureTaken) {
      return SinglePicture(imagePath: _cameraService.imagePath!);
    }
    return CameraDetectionPrev();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = getBodyWidget();
    return Scaffold(
      body: Stack(
        children: [body],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          !_isPictureTaken ? AuthButton(onTap: onTap) : Container(),
      // floatingActionButton:
    );
  }
}

class AuthButton extends StatelessWidget {
  final void Function() onTap;
  const AuthButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Constants.primaryColor,
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        width: MediaQuery.of(context).size.width * 0.8,
        height: 60,
        child: const DefaultText(
          size: 18,
          text: 'CAPTURE',
          color: Colors.white,
          weight: FontWeight.bold,
        ),
      ),
    );
  }
}
