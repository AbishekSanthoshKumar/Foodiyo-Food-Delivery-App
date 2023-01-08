// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodiyo/global/global.dart';
import 'package:foodiyo/main.dart';
import 'package:foodiyo/restaurant/rest_home_screen.dart';

import 'customer/cust_home_screen.dart';

const isLoggedIn = 'LoggedIn';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void didChangeDependencies() {
    // ignore: todo
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  startTimer() {
    Timer(const Duration(seconds: 3), () async {
      if (firebaseAuths.currentUser != null) {
        print('User exists');
        if (sharedPreferences!.get('type').toString() == 'Restaurant') {
          print('Restaurant');
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RestHomeScreen(currentUser: firebaseAuths.currentUser!,),
              ));
        } else if (sharedPreferences!.get('type').toString() == 'Customer') {
          print('Customer');
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustHomeScreen(currentUser: firebaseAuths.currentUser!,),
              ));
        }
      }else {
        print('User does not exist');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const MainPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[900],
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to',
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Image.asset(
              'images/Foodiyo.png',
              height: 300,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // ignore: todo
    //TODO: implement dispose
    super.dispose();
  }
}
