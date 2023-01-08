import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodiyo/customer/cust_login.dart';
import 'package:foodiyo/global/global.dart';
import 'package:foodiyo/restaurant/rest_login.dart';
import 'package:foodiyo/splash.dart';
import 'package:foodiyo/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  sharedPreferences = await SharedPreferences.getInstance();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  //final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const SplashScreen(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/detailbgs.jpg'),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Are you ',
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 50,
            ),
            CustomButton(
              msg: 'Customer',
              wid: CustLogin(),
            ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              'or',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            const SizedBox(
              height: 25,
            ),
            CustomButton(
              msg: 'Restaurant',
              wid: RestLogin(),
            ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              'or',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            const SizedBox(
              height: 25,
            ),
            GestureDetector(
              child: Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          offset: -const Offset(5, 5),
                          color: Colors.black,
                          blurRadius: 20),
                      const BoxShadow(
                          offset: Offset(5, 5),
                          color: Colors.black,
                          blurRadius: 20)
                    ],
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(30)),
                child: const Center(
                  child: Text('Guest',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}
