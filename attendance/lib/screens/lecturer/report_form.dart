import 'package:attendance/components/defaultButton.dart';
import 'package:attendance/components/defaultText.dart';
import 'package:attendance/components/defaultTextFormField.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ReportForm extends StatefulWidget {
  const ReportForm({super.key});

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  bool percent = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const DefaultText(
          size: 18,
          text: 'Generate Attendance Report',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const DefaultText(
                  size: 15,
                  text: "Include Performance \n Percent",
                  align: TextAlign.center,
                ),
                Switch(
                    value: percent,
                    onChanged: (value) {
                      setState(() {
                        percent = value;
                      });
                      print(percent);
                    })
              ],
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: Form(
                  child: Column(
                children: [
                  DefaultTextFormField(
                      onSaved: (newVal) {},
                      validator: (String? value) {
                        if (value!.isEmpty) return "field is required";
                      },
                      hintText: 'from date',
                      fontSize: 15.0),
                  const SizedBox(height: 20.0),
                  DefaultTextFormField(
                      onSaved: (newVal) {},
                      validator: (String? value) {
                        if (value!.isEmpty) return "field is required";
                      },
                      hintText: 'to date',
                      fontSize: 15.0),
                ],
              )),
            ),
            const Spacer(),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: DefaultButton(
                    onPressed: () {},
                    text: 'Generate New Report',
                    textSize: 18))
          ],
        ),
      ),
    );
  }
}
