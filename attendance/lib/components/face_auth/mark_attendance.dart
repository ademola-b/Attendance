import 'package:attendance/components/defaultText.dart';
import 'package:attendance/components/face_auth/widgets/face_painter.dart';
import 'package:attendance/components/face_auth/widgets/mark_attendance_plugs.dart';
import 'package:attendance/components/face_auth/widgets/single_picture.dart';
import 'package:attendance/locator.dart';
import 'package:attendance/models/attendance.dart';
import 'package:attendance/models/studentFace.dart';
import 'package:attendance/services/cameraService.dart';
import 'package:attendance/services/faceDetectorService.dart';
import 'package:attendance/services/mlService.dart';
import 'package:attendance/services/remoteServices.dart';
import 'package:attendance/utils/constants.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

// import 'dart:math' as math;

class MarkAttendanceFace extends StatefulWidget {
  final arguments;
  const MarkAttendanceFace(
    Object? this.arguments, {
    Key? key,
  }) : super(key: key);

  @override
  State<MarkAttendanceFace> createState() => _MarkAttendanceFaceState();
}

class _MarkAttendanceFaceState extends State<MarkAttendanceFace> {
  CameraService _cameraService = locator<CameraService>();
  FaceDetectorService _faceDetectorService = locator<FaceDetectorService>();
  MLService _mlService = locator<MLService>();

  bool _isInitializing = false;
  bool _isPictureTaken = false;

  List<Attendance?>? markedAtt = [];

  Future<List<Attendance>?> _getMarkedAttendance(int slot_id) async {
    List<Attendance>? _att =
        await RemoteService.getMarkedAttendance(context, slot_id);
    if (_att != null) {
      return _att;
    }
  }

  @override
  void initState() {
    super.initState();

    _start();
    print("Widget data: ${widget.arguments}");
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
    List<Attendance>? _att = await RemoteService.getMarkedAttendance(
        context, widget.arguments['slot_id']);
    if (_att != null && _att.isEmpty) {
      await takePicture();
      if (_faceDetectorService.faceDetected) {
        StudentFace? stdFace = await _mlService.predict();
        if (stdFace != null) {
          Attendance? markAtt = await RemoteService.markAttendance(
              context, widget.arguments['slot_id']);

          markAtt != null
              ? Constants.DialogBox(context, "Attendance Marked", Colors.white,
                  Icons.check_circle_outline)
              : Constants.DialogBox(context, "An error occured", Colors.amber,
                  Icons.warning_amber_rounded);
        } else {
          Constants.DialogBox(context, "Unrecognized Face!",
          Colors.amber, Icons.warning_amber_outlined);
        }
      }
    } else {
      Constants.DialogBox(context, "You've marked attendance already",
          Colors.amber, Icons.warning_amber_outlined);
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
