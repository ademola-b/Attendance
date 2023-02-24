// import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data';

// import 'package:attendance/models/userFace.dart';
// import 'package:attendance/utils/local_db.dart';
// import 'package:camera/camera.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:image/image.dart' as imglib;

// import 'image_converted.dart';

// class MLService {
//   late Interpreter interpreter;
//   List? predictedArray;

//   //predict the image(to be converted to array)
//   //get the image from camera, convert to a list then generate an output from it.
//   //then compare the generated output with the one stored in database.

//   Future<UserFace?> predict(
//       CameraImage image, Face face, bool loginUser, String name) async {
//     List input = _preProcess(image, face);
//     input = input.reshape([1, 112, 112, 3]);

//     List output = List.generate(1, (index) => List.filled(192, 0));

//     //get the platform the image is coming from (Android or iOS)
//     await initializeInterpreter();

//     interpreter.run(input, output);
//     output = output.reshape([192]);

//     //result from inputted image
//     predictedArray = List.from(output);

//     //to register a face
//     if (!loginUser) {
//       LocalDB.setUserDetails(UserFace(name: name, array: predictedArray));
//       return null;
//     } else {
//       //to compare faces - using euclidean face
//       //if there's a match, return the user's details else return null
//       UserFace? userFace = LocalDB.getUser();
//       List userFaceArray = userFace.array!;
//       int minimumDistance = 999;
//       double threshold = 1.5;
//       var distance = euclideanDistance(predictedArray!, userFaceArray);
//       if (distance <= threshold && distance < minimumDistance) {
//         return userFace;
//       } else {
//         return null;
//       }
//     }
//   }

//   euclideanDistance(List predictedArray, List userFaceArray) {
//     double sum = 0;
//     for (int i = 0; i < predictedArray.length; i++) {
//       sum += pow((predictedArray[i] - userFaceArray[i]), 2);
//     }

//     return pow(sum, 0.5);
//   }

//   List _preProcess(CameraImage image, Face detectedFace) {
//     imglib.Image croppedImage = _cropFace(image, detectedFace);
//     imglib.Image img = imglib.copyResizeCropSquare(croppedImage, 112);

//     Float32List imageAsList = _imageToByteListFloat32(img);

//     return imageAsList;
//   }

//   imglib.Image _cropFace(CameraImage image, Face detectedFace) {
//     imglib.Image convertedImage = _convertCameraImage(image);
//     double x = detectedFace.boundingBox.left - 10.0;
//     double y = detectedFace.boundingBox.top - 10.0;
//     double w = detectedFace.boundingBox.width + 10.0;
//     double h = detectedFace.boundingBox.height + 10.0;

//     return imglib.copyCrop(
//         convertedImage, x.round(), y.round(), w.round(), h.round());
//   }

//   imglib.Image _convertCameraImage(CameraImage image) {
//     var img = convertToImage(image);
//     var img1 = imglib.copyRotate(img!, -90);

//     return img1;
//   }

//   Float32List _imageToByteListFloat32(imglib.Image image) {
//     var convertedBytes = Float32List(1 * 112 * 112 * 3);
//     var buffer = Float32List.view(convertedBytes.buffer);
//     int pixelIndex = 0;

//     for (var i = 0; i < 112; i++) {
//       for (var j = 0; j < 112; j++) {
//         var pixel = image.getPixel(j, i);
//         buffer[pixelIndex++] = (imglib.getRed(pixel) - 128) / 128;
//         buffer[pixelIndex++] = (imglib.getGreen(pixel) - 128) / 128;
//         buffer[pixelIndex++] = (imglib.getBlue(pixel) - 128) / 128;
//       }
//     }

//     return convertedBytes.buffer.asFloat32List();
//   }

//   //interpret image for different platforms
//   //delegateV2 for android
//   initializeInterpreter() async {
//     Delegate? delegate;
//     try {
//       if (Platform.isAndroid) {
//         delegate = GpuDelegateV2(
//             options: GpuDelegateOptionsV2(
//           isPrecisionLossAllowed: false,
//           inferencePreference: TfLiteGpuInferenceUsage.fastSingleAnswer,
//           inferencePriority1: TfLiteGpuInferencePriority.minLatency,
//           inferencePriority2: TfLiteGpuInferencePriority.auto,
//           inferencePriority3: TfLiteGpuInferencePriority.auto,
//         ));
//       } else if (Platform.isIOS) {
//         delegate = GpuDelegate(
//           options: GpuDelegateOptions(
//               allowPrecisionLoss: true,
//               waitType: TFLGpuDelegateWaitType.active),
//         );
//       }
//       var interpreterOptions = InterpreterOptions()..addDelegate(delegate!);

//       interpreter = await Interpreter.fromAsset("assets/mobilefacenet.tflite",
//           options: interpreterOptions);
//     } catch (e) {
//       print('Failed to load model.');
//       print(e);
//     }
//   }
// }
