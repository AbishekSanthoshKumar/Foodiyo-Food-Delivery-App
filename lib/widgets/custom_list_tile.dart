// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  CustomListTile({Key? key, required this.msg, required this.icon})
      : super(key: key);

  String msg;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.withOpacity(0.4),
        ),
        child: ListTile(
          leading: Icon(icon),
          title: Text(
            msg,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
