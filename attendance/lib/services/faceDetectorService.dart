import 'dart:ui';

import 'package:attendance/locator.dart';
import 'package:attendance/services/cameraService.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class FaceDetectorService {
  CameraService _cameraService = locator<CameraService>();

  late FaceDetector _faceDetector;
  FaceDetector get faceDetector => _faceDetector;

  List<Face> _faces = [];
  List<Face> get faces => _faces; //getter method for faces

  bool get faceDetected => _faces.isNotEmpty; //getter method

  Future<void> initialize() async {
    _faceDetector = GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
      mode: FaceDetectorMode.accurate,
    ));
  }

  //detect faces from the camera image and convert to array
  Future<void> detectFacesFromImage(CameraImage image) async {
    InputImageData firebaseImageMetadata = InputImageData(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      imageRotation:
          _cameraService.cameraRotation ?? InputImageRotation.Rotation_0deg,
      inputImageFormat:
          InputImageFormatMethods.fromRawValue(image.format.raw) ??
              InputImageFormat.NV21,
      planeData: image.planes.map((Plane plane) {
        return InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width);
      }).toList(),
    );

    //image created from bytes
    InputImage firebaseVisionImage = InputImage.fromBytes(
        bytes: image.planes[0].bytes, inputImageData: firebaseImageMetadata);

    //convert faces to array
    _faces = await _faceDetector.processImage(firebaseVisionImage);

   
  }

  dispose() {
    _faceDetector.close();
  }
}
