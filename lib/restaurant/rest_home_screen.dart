// ignore_for_file: use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodiyo/customer/user_profile.dart';
import 'package:foodiyo/global/global.dart';
import 'package:foodiyo/main.dart';
import 'package:foodiyo/models/rest_menu.dart';
import 'package:foodiyo/restaurant/add_menu_item.dart';
import 'package:foodiyo/restaurant/rest_food_display.dart';
import 'package:foodiyo/restaurant/rest_profile.dart';
import 'package:foodiyo/restaurant/update_menu_item.dart';
import 'package:foodiyo/widgets/foodiyo_about.dart';
import 'package:foodiyo/widgets/snackbar.dart';
import 'package:google_fonts/google_fonts.dart';

class RestHomeScreen extends StatelessWidget {
  const RestHomeScreen({required this.currentUser});
  final User currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AddMenuItem())),
        child: const Icon(
          Icons.add,
          color: Colors.amber,
        ),
        backgroundColor: Colors.white,
      ),
      drawer: RestHomeDrawer(
        currentUser: currentUser,
      ),
      appBar: AppBar(
        title: Text(
          sharedPreferences!.get('name').toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.blueGrey[100],
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/detailbgs.jpg'),
                fit: BoxFit.fitHeight)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                child: Image.asset('images/Foodiyo.png'),
                height: 200,
              ),
              Stack(children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      height: 200,
                      width: 1000,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.blueGrey,
                      ),
                      height: 290,
                      width: 1000,
                    ),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.blueGrey,
                      ),
                      height: 150,
                      width: 1000,
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(
                          'Your Menu',
                          style: GoogleFonts.hurricane(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 430,
                      child: StreamBuilder<List<Menu>>(
                        stream: readMenu(
                            '${sharedPreferences!.get('name').toString()}_menu'),
                        builder: (ctx, snapshot) {
                          if (snapshot.hasData) {
                            final menu = snapshot.data!;
                            return ListView(
                              children: menu.map(buildMenu).toList(),
                            );
                          } else {
                            return const Text('Something has happened');
                          }
                        },
                      ),
                    ),
                  ],
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenu(Menu menu) {
    return GestureDetector(
      onTap: () => Navigator.push(NavigationService.navigatorKey.currentContext!, MaterialPageRoute(builder: ((context) => RestFoodDisplay(menu: menu)))),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.amber,
          ),
          height: 150,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(menu.photoURL),
                  radius: 55),
              const SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menu.name,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  SizedBox(
                    width: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        menu.veg.toUpperCase() == 'VEG'
                            ? Image.asset(
                                'images/veg.png',
                                height: 30,
                              )
                            : Image.asset(
                                'images/non_veg.png',
                                height: 30,
                              ),
                        Text(
                          'Rs.${menu.price}',
                          style: const TextStyle(fontSize: 15),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            // final docUser = FirebaseFirestore.instance.collection('${sharedPreferences!.get('name').toString()}_menu').doc('${menu.name}');
                            // docUser.update({});
                            Navigator.push(NavigationService.navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => UpdateMenuItem(menu: menu,)));
                          },
                          icon: const Icon(Icons.upload)),
                      IconButton(onPressed: () {
                        final docUser = FirebaseFirestore.instance.collection('${sharedPreferences!.get('name').toString()}_menu').doc(menu.id);
                        docUser.delete().then((value) => callCustomSnackbar(NavigationService.navigatorKey.currentContext!, 'Item Deleted'));
                      }, icon: const Icon(Icons.delete)),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
    );
  }
}

class RestHomeDrawer extends StatefulWidget {
  const RestHomeDrawer({Key? key, required this.currentUser}) : super(key: key);
  final User currentUser;

  @override
  State<RestHomeDrawer> createState() => _RestHomeDrawerState();
}

class _RestHomeDrawerState extends State<RestHomeDrawer> {
  String url = '';

  getImgUrl() async {
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(widget.currentUser.uid)
        .get()
        .then((userData) {
      setState(() {
        url = userData.data()!['photo'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getImgUrl();
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPictureSize: const Size.square(89),
            currentAccountPicture:
                CircleAvatar(backgroundImage: NetworkImage(url)),
            accountName: const Text(''),
            accountEmail: Text(
              '${sharedPreferences!.get('name')}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          GestureDetector(
            child:
                const DrawerItem(txt: 'User Profile', iconData: Icons.person),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RestProfile(currentUser: widget.currentUser),
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const About(),
                )),
            child: const DrawerItem(
                txt: 'About Foodiyo', iconData: Icons.perm_device_information),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            child: const DrawerItem(txt: 'Logout', iconData: Icons.logout),
            onTap: () => firebaseAuths.signOut().then((value) =>
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainPage()),
                    (route) => false)),
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem(
      {Key? key, required this.txt, required this.iconData, this.type})
      : super(key: key);
  final String txt;
  final IconData iconData;
  final Widget? type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
          child: Card(
        child: ListTile(
            title: Text(
              txt,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            leading: Icon(iconData)),
        color: Colors.grey[200],
      )),
    );
  }
}
