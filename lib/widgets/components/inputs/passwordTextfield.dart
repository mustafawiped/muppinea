import 'package:flutter/material.dart';

class createPasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? changed;
  final bool errorState;
  final String errorText;
  final GestureDetector visibility;
  final bool obscureState;
  const createPasswordTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.changed,
      required this.errorState,
      required this.errorText,
      required this.visibility,
      required this.obscureState});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 40,
      onChanged: changed,
      controller: controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: !obscureState,
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
          Icons.password,
          color: Color.fromARGB(255, 32, 32, 32),
        ),
        fillColor: Colors.white,
        filled: true,
        border: InputBorder.none,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        counterText: "",
        errorText: errorState ? errorText : null,
        suffixIcon: visibility,
      ),
    );
  }
}
