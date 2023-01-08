import 'package:flutter/material.dart';

class MyLoadingDialog extends StatelessWidget {
  const MyLoadingDialog({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circularProgress(),
          const SizedBox(
            height: 10,
          ),
          const Text('Please Wait')
        ],
      ),
    );
  }

  circularProgress() {
  return Container(
    padding: const EdgeInsets.only(top: 12),
    child: const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        Colors.red,
      ),
    ),
  );
}
}