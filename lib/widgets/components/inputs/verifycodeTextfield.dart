// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class createVerifyCodeTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? changed;
  final bool errorState;
  final String errorText;
  const createVerifyCodeTextfield({
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
      maxLength: 11,
      onChanged: changed,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      controller: controller,
      keyboardType: TextInputType.number,
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
        prefixIcon: const Icon(
          Icons.lock_clock_sharp,
          color: Color.fromARGB(255, 32, 32, 32),
        ),
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
