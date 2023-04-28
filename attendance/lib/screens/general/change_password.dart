import 'package:attendance/components/defaultButton.dart';
import 'package:attendance/components/defaultText.dart';
import 'package:attendance/components/defaultTextFormField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _form = GlobalKey<FormState>();
  TextEditingController? oldPassword;
  TextEditingController? newPassword;

  String? _old, _new;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: const DefaultText(size: 18.0, text: 'Change Password'),
            centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(children: [
            Form(
              key: _form,
              child: Expanded(
                flex: 2,
                child: Column(
                  children: [
                    DefaultTextFormField(
                      controller: oldPassword,
                      hintText: "Old Password",
                      fontSize: 15.0,
                      onSaved: (newVal) {
                        _old = newVal!;
                      },
                      validator: (String? value) {
                        if (value!.isEmpty) return "Latitude is required";
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    DefaultTextFormField(
                      controller: newPassword,
                      fontSize: 15.0,
                      hintText: 'New Password',
                      onSaved: (newVal) {
                        _new = newVal!;
                      },
                      validator: (String? value) {
                        if (value!.isEmpty) return "Longitude is required";
                        return null;
                      },
                    ),
                    const SizedBox(height: 50.0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: DefaultButton(
                          onPressed: () {}, text: "SUBMIT", textSize: 18.0),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
