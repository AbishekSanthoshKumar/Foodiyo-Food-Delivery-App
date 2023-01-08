// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class MyErrorDialog extends StatelessWidget {
  MyErrorDialog({Key? key, required this.msg}) : super(key: key);

  String msg;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      key: key,
      content: Text(
        msg,
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        )
      ],
    );
  }
}
