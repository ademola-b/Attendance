import 'dart:io';
import 'dart:math' as math;
import 'package:attendance/components/defaultText.dart';
import 'package:attendance/components/face_auth/widgets/auth-action-button.dart';
import 'package:attendance/components/face_auth/widgets/face_painter.dart';
import 'package:attendance/locator.dart';
import 'package:attendance/models/studentFace.dart';

import 'package:attendance/models/userFace.dart';
import 'package:attendance/services/cameraService.dart';
import 'package:attendance/services/faceDetectorService.dart';
import 'package:attendance/services/mlService.dart';
import 'package:attendance/utils/constants.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:lottie/lottie.dart';

//initialize the device cameras
// List<CameraDescription>? cameras;

class FaceScanScreen extends StatefulWidget {
  // final UserFace? userFace;
  const FaceScanScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<FaceScanScreen> createState() => _FaceScanScreenState();
}

class _FaceScanScreenState extends State<FaceScanScreen> {
  Face? faceDetected;
  String? imagePath;
  Size? imageSize;

  bool _initializing = false;
  bool pictureTaken = false;

  bool _detectingFaces = false;
  bool _saving = false;

  bool _bottomSheetVisible = false;

  //services
  final FaceDetectorService _faceDetectorService = locator<FaceDetectorService>();
  final CameraService _cameraService = locator<CameraService>();
  final MLService _mlService = locator<MLService>();

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  _start() async {
    setState(() => _initializing = true);
    await _cameraService.initialize(); //start the camera
    // await _faceDetectorService.initialize();
    setState(() => _initializing = false); //why?

    _frameFaces();
  }

  _frameFaces() {
    imageSize = _cameraService.getImageSize();

    _cameraService.cameraController?.startImageStream((image) async {
      if (_cameraService.cameraController != null) {
        if (_detectingFaces) return;

        _detectingFaces = true;

        try {
          await _faceDetectorService.detectFacesFromImage(image);

          if (_faceDetectorService.faces.isNotEmpty) {
            setState(() {
              faceDetected = _faceDetectorService.faces[0];
            });

            if (_saving) {
              _mlService.setCurrentPrediction(image, faceDetected);

              setState(() {
                _saving = false;
              });
            }
          } else {
            setState(() {
              faceDetected = null;
            });
          }

          _detectingFaces = false;
        } catch (e) {
          print(e);
          _detectingFaces = false;
        }
      }
    });
  }

  Future<bool> onShot() async {
    if (faceDetected == null) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('No face detected!'),
          );
        },
      );

      return false;
    } else {
      _saving = true;
      await Future.delayed(Duration(milliseconds: 500));
      await Future.delayed(Duration(milliseconds: 200));
      XFile? file = await _cameraService.takePicture();
      imagePath = file?.path;

      setState(() {
        // _bottomSheetVisible = true;
        pictureTaken = true;
      });

      return true;
    }
  }

  _reload() {
    setState(() {
      pictureTaken = false;
    });

    _start();
  }

  @override
  Widget build(BuildContext context) {
    final double mirror = math.pi;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    late Widget cameraBody;
    if (_initializing) {
      cameraBody = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!_initializing && pictureTaken) {
      cameraBody = Container(
        width: width,
        height: height,
        child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(mirror),
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.file(File(imagePath!)),
            )),
      );
    }

    if (!_initializing && !pictureTaken) {
      cameraBody = Transform.scale(
        scale: 1.0,
        child: AspectRatio(
          aspectRatio: MediaQuery.of(context).size.aspectRatio,
          child: OverflowBox(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Container(
                width: width,
                height:
                    width * _cameraService.cameraController!.value.aspectRatio,
                child: Stack(fit: StackFit.expand, children: [
                  CameraPreview(_cameraService.cameraController!),
                  CustomPaint(
                    painter:
                        FacePainter(face: faceDetected, imageSize: imageSize!),
                  )
                ]),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Register Face'),
        //   centerTitle: true,
        // ),
        body: Stack(
          children: [
            cameraBody,
            Container(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            AuthActionButton(onPressed: onShot, isLogin: false, reload: _reload));
  }
}
