import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodiyo/global/global.dart';

class RestProfile extends StatefulWidget {
  const RestProfile({Key? key, required this.currentUser}) : super(key: key);
  final User currentUser;

  @override
  State<RestProfile> createState() => _RestProfileState();
}

class _RestProfileState extends State<RestProfile> {
  String address = '';
  String email = '';
  String photo = '';
  String phone = '';
  String id = '';

  TextStyle style = const TextStyle(
      fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            CircleAvatar(
              radius: 100,
              backgroundImage: NetworkImage(photo),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              sharedPreferences!.get('name').toString(),
              textAlign: TextAlign.center,
              style: style,
            ),
            const SizedBox(
              height: 20,
            ),
            Table(
              columnWidths: const {
                0: FractionColumnWidth(0.40),
                1: FractionColumnWidth(0.60),
              },
              border: const TableBorder(),
              children: [
                buildRow(['Location', address]),
                buildRow(['Email', email]),
                buildRow(['Phone', '(+91) ' + phone]),
                buildRow(['Foodiyo ID', id])
              ],
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  TableRow buildRow(List<String> cells) {
    return TableRow(
        children: cells
            .map((cell) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    cell,
                    style: const TextStyle(fontSize: 17),
                  ),
                ))
            .toList());
  }

  getData() async {
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(widget.currentUser.uid)
        .get()
        .then((userData) {
      setState(() {
        address = userData.data()!['location'];
        email = userData.data()!['email'];
        phone = userData.data()!['phone'];
        id = userData.data()!['id'];
        photo = userData.data()!['photo'];
      });
    });
  }
}
