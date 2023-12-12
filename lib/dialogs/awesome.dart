// ignore_for_file: camel_case_types

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class awesomeDialog {
  // Awesome Dialog
  void show(
      BuildContext context,
      String header,
      String desc,
      String button1Text,
      String button2Text,
      DialogType dialogType,
      Function()? btn1Func,
      Function()? btn2Func) {
    AwesomeDialog(
      context: context,
      dialogBackgroundColor: const Color.fromARGB(255, 32, 32, 32),
      btnOkColor: Colors.red,
      btnCancelColor: Colors.blue,
      titleTextStyle: const TextStyle(color: Colors.white),
      descTextStyle: const TextStyle(color: Colors.white),
      dialogType: dialogType,
      animType: AnimType.topSlide,
      btnOkText: button1Text,
      btnCancelText: button2Text,
      title: header,
      desc: desc,
      btnOkOnPress: btn1Func,
      btnCancelOnPress: btn2Func,
    ).show();
  }
}
