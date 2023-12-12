// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class loadingDilaog {
  void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: 150.0,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: Color.fromARGB(255, 225, 57, 255),
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
