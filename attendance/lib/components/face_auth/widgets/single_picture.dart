import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class SinglePicture extends StatelessWidget {
  final String imagePath;

  const SinglePicture({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double mirror = math.pi;

    return Container(
      width: size.width,
      height: size.height,
      child: Transform(
        transform: Matrix4.rotationX(mirror),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.cover,
          child: Image.file(File(imagePath)),
        ),
      ),
    );
  }
}
