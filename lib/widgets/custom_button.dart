// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  
  CustomButton({Key? key, required this.msg, required this.wid}) : super(key: key);
  
  final String msg;
  final Widget wid;
  Offset distance = const Offset(5, 5);
  double blur = 20;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => wid,)),
      child: Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(offset: -distance, color: Colors.black, blurRadius: blur),
          BoxShadow(offset: distance, color: Colors.black, blurRadius: blur)
        ], color: Colors.blueGrey, borderRadius: BorderRadius.circular(30)),
        child: Center(
          child: Text(msg,
              style: const TextStyle(fontSize: 20, color: Colors.white)),
        ),
      ),
    );
  }
}
