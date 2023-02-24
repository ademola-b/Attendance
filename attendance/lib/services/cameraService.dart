import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class CameraService {
  CameraController? _cameraController; //used to get the camera description, resolution
  CameraController? get cameraController =>
      this._cameraController; //getter method

  InputImageRotation? _cameraRotation;
  InputImageRotation? get cameraRotation => this._cameraRotation;

  String? _imagePath;
  String? get imagePath => this._imagePath;

  Future<void> initialize() async {
    if (_cameraController != null) {
      //check if no camera property has been set
      return;
    }
    CameraDescription desc = await _getCameraDesc(); //frontCamera

    await _setupCameraController(desc: desc); //wait till camera starts
    this._cameraRotation = rotationInttoImageRotation(desc.sensorOrientation); //for cameras in landscape mode
  }

  //get camera
  Future<CameraDescription> _getCameraDesc() async {
    List<CameraDescription> cameras =
        await availableCameras(); //get the list of the device cameras(front and back)
    return cameras.firstWhere((CameraDescription camera) =>
        camera.lensDirection ==
        CameraLensDirection.front); //get the front camera
  }

  Future _setupCameraController({required CameraDescription desc}) async {
    _cameraController =
        CameraController(desc, ResolutionPreset.high, enableAudio: false); //constructor class

    await _cameraController?.initialize(); //starts the camera
  }

  InputImageRotation rotationInttoImageRotation(int rotation) {
    switch (rotation) {
      case 90:
        return InputImageRotation.Rotation_90deg;
      case 180:
        return InputImageRotation.Rotation_180deg;
      case 270:
        return InputImageRotation.Rotation_270deg;
      default:
        return InputImageRotation.Rotation_0deg;
    }
  }

  Future<XFile?> takePicture() async {
    assert(_cameraController != null, 'Camera controller not intialized'); //throws an exception if cameraController is null
    await _cameraController?.stopImageStream();
    XFile? file = await _cameraController?.takePicture();
    _imagePath = file?.path;
    return file;
  }

  Size getImageSize() {
    assert(_cameraController != null,
        'Camera controller not initialized'); //insert exception
    assert(
        _cameraController!.value.previewSize != null, 'Preview size is null');
    return Size(
      _cameraController!.value.previewSize!.height,
      _cameraController!.value.previewSize!.width,
    );
  }

  dispose() async {
    await _cameraController?.dispose();
    _cameraController = null;
  }
}
