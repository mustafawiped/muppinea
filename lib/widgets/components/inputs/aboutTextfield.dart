// ignore_for_file: file_names

import 'package:flutter/material.dart';

// ignore: camel_case_types
class createAboutTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? changed;
  final bool errorState;
  final String errorText;
  const createAboutTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.changed,
    required this.errorState,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 300,
      onChanged: changed,
      controller: controller,
      minLines: 4,
      maxLines: 5,
      decoration: InputDecoration(
        enabledBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        errorBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        focusedBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        disabledBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        focusedErrorBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        fillColor: Colors.white,
        filled: true,
        border: InputBorder.none,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        counterText: "",
        errorText: errorState ? errorText : null,
      ),
    );
  }
}
