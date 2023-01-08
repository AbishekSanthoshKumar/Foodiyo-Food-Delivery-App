// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController txt;
  final IconData? iconData;
  TextInputType? textInputType = TextInputType.text;
  final String hintText;
  bool isObscure = true;
  bool? enabled = true;

  CustomTextField(
      {required this.isObscure,
      this.textInputType,
      this.enabled,
      required this.txt,
      this.iconData,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TextFormField(
        keyboardType: textInputType,
        style: const TextStyle(
          color: Colors.white,
        ),
        validator: (value) =>
            (value == null || value.isEmpty) ? "Please enter $hintText" : null,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blueGrey.withOpacity(0.6),
            errorStyle: const TextStyle(fontWeight: FontWeight.bold),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            labelText: hintText,
            labelStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
            prefixIcon: Icon(iconData, color: Colors.white.withOpacity(0.9))),
        obscureText: isObscure,
        cursorColor: Theme.of(context).primaryColor,
        enabled: enabled,
        controller: txt,
      ),
    );
  }
}
