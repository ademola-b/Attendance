import 'package:attendance/components/face_auth/widgets/face_painter.dart';
import 'package:attendance/locator.dart';
import 'package:attendance/services/cameraService.dart';
import 'package:attendance/services/faceDetectorService.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraDetectionPrev extends StatelessWidget {
  final _cameraService = locator<CameraService>();
  final _faceDetectorService = locator<FaceDetectorService>();

  CameraDetectionPrev({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Transform.scale(
      scale: 1.0,
      child: AspectRatio(
        aspectRatio: MediaQuery.of(context).size.aspectRatio,
        child: OverflowBox(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Container(
                width: width,
                height: width *
                    _cameraService.cameraController!.value.aspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    CameraPreview(
                        _cameraService.cameraController!), //live camera preview
                    //draw circle around face if detected
                    _faceDetectorService.faceDetected
                        ? CustomPaint(
                            painter: FacePainter(
                                imageSize: _cameraService.getImageSize(),
                                face: _faceDetectorService.faces[0]),
                          )
                        : Container(),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

