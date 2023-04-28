import 'package:attendance/components/defaultButton.dart';
import 'package:attendance/components/defaultText.dart';
import 'package:attendance/components/defaultTextFormField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({super.key});

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  final _form = GlobalKey<FormState>();
  TextEditingController? oldPassword;
  TextEditingController? newPassword;

  String? _old, _new;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: const DefaultText(size: 18.0, text: 'About Application'),
            centerTitle: true),
        body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Center(
              child: DefaultText(size: 18.0, text: "About Application"),
            )),
      ),
    );
  }
}
