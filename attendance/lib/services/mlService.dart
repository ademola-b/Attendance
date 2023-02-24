import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:attendance/components/face_auth/image_converted.dart';
import 'package:attendance/models/studentFace.dart';
import 'package:attendance/services/image_converter.dart';
import 'package:attendance/services/remoteServices.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imglib;

class MLService {
  Interpreter? _interpreter;
  double threshold = 0.5; //1 seems too high

  late List _predictedData;
  List get predictedData => _predictedData; //getter method

  late List _flat;
  List get predFlat => _flat;

  Future initialize() async {
    late Delegate delegate; //platform: iOS or Android
    try {
      if (Platform.isAndroid) {
        delegate = GpuDelegateV2(
          options: GpuDelegateOptionsV2(
            inferencePreference: TfLiteGpuInferenceUsage.fastSingleAnswer,
            inferencePriority1: TfLiteGpuInferencePriority.minLatency,
            inferencePriority2: TfLiteGpuInferencePriority.auto,
            inferencePriority3: TfLiteGpuInferencePriority.auto,
          ),
        );
      } else if (Platform.isIOS) {
        delegate = GpuDelegate(
          options: GpuDelegateOptions(
              allowPrecisionLoss: true,
              waitType: TFLGpuDelegateWaitType.active),
        );
      }

      var interpreterOptions = InterpreterOptions()..addDelegate(delegate);

      this._interpreter = await Interpreter.fromAsset('mobilefacenet.tflite',
          options: interpreterOptions);
    } catch (e) {
      print('Failed to load model');
      print(e);
    }
  }

  void setCurrentPrediction(CameraImage cameraImage, Face? face) async {
    if (_interpreter == null) throw Exception('Interpreter is null');
    if (face == null) throw Exception('Face is null');

    //convert the inputted image to a list, the face is array of snapped face(detected)
    List input = _preProcess(cameraImage, face);

    input = input.reshape([1, 112, 112, 3]);

    List output = List.generate(1, (index) => List.filled(192, 0));
    this._interpreter?.run(input, output);
    output.reshape([192]);

    this._predictedData = List.from(output);

    _flat = predictedData
        .expand((e) => e)
        .toList(); //convert the list of list to list
  }

  // Future prd() async {
  //   return this._predictedData;
  // }

  Future<StudentFace?> predict() async {
    return _searchResult(this._predictedData);
  }

  Future<StudentFace?> _searchResult(List predictedData) async {
    List<StudentFace?>? stdFace = await RemoteService().studentFace();
    // StudentFace? stdFace = await RemoteService().studentFace();

    print(predictedData);

    double minDist = 999;
    double currDist = 0.0;
    StudentFace? predictedResult;

    for (StudentFace? std in stdFace!) {
      currDist = _euclideanDistance(std!.studentFace, _flat);
      if (currDist <= threshold && currDist < minDist) {
        minDist = currDist;
        predictedResult = std;
      } else {
        return null;
      }
    }

    return predictedResult;
  }

  double _euclideanDistance(List? l1, List? l2) {
    if (l1 == null || l2 == null) throw Exception("Null argument");

    double sum = 0.0;
    for (int i = 0; i < l1.length; i++) {
      sum += pow((l1[i] - l2[i]), 2);
    }
    return sqrt(sum);
  }

  void setPredictedData(value) {
    this._predictedData = value;
  }

  List _preProcess(CameraImage image, Face faceDetected) {
    imglib.Image croppedImage = _cropFace(image, faceDetected);
    imglib.Image img = imglib.copyResizeCropSquare(croppedImage, 112);

    Float32List imageAsList = imageToByteListFloat32(img);
    return imageAsList;
  }

  imglib.Image _cropFace(CameraImage image, Face faceDetected) {
    imglib.Image convertedImage = _convertCameraImage(image);
    double x = faceDetected.boundingBox.left - 10.0;
    double y = faceDetected.boundingBox.top - 10.0;
    double w = faceDetected.boundingBox.width + 10.0;
    double h = faceDetected.boundingBox.height + 10.0;
    return imglib.copyCrop(
        convertedImage, x.round(), y.round(), w.round(), h.round());
  }

  imglib.Image _convertCameraImage(CameraImage image) {
    var img = convertToImage(image);
    var img1 = imglib.copyRotate(img, -90);
    return img1;
  }

  Float32List imageToByteListFloat32(imglib.Image image) {
    var convertedBytes = Float32List(1 * 112 * 112 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);

    int pixelIndex = 0;
    for (var i = 0; i < 112; i++) {
      for (var j = 0; j < 112; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (imglib.getRed(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getGreen(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getBlue(pixel) - 128) / 128;
      }
    }

    return convertedBytes.buffer.asFloat32List();
  }
}
