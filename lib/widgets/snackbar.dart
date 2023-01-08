import 'package:flutter/material.dart';

callCustomSnackbar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(seconds: 2),
    content: Text(
      msg,
      textAlign: TextAlign.center,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.red[400]!.withOpacity(0.8),
  ));
}
