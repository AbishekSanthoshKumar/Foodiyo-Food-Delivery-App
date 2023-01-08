import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodiyo/global/global.dart';
import 'package:foodiyo/main.dart';
import 'package:foodiyo/models/rest_menu.dart';
import 'package:foodiyo/restaurant/update_menu_item.dart';
import 'package:foodiyo/widgets/food_display.dart';
import 'package:foodiyo/widgets/snackbar.dart';

class RestFoodDisplay extends StatelessWidget {
  const RestFoodDisplay({Key? key, required this.menu}) : super(key: key);
  final Menu menu;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UpdateMenuItem(
                        menu: menu,
                      ))).then((value) => Navigator.pop(context));
        },
        child: const Icon(
          Icons.upload,
          color: Colors.black,
        ),
        backgroundColor: Colors.amber,
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                final docUser = FirebaseFirestore.instance
                    .collection(
                        '${sharedPreferences!.get('name').toString()}_menu')
                    .doc(menu.id);
                docUser.delete().then((value) {
                  Navigator.pop(context);
                  callCustomSnackbar(
                      NavigationService.navigatorKey.currentContext!,
                      'Item Deleted');
                });
              },
              icon: Icon(Icons.delete, color: Colors.red[400]))
        ],
        centerTitle: true,
        title: Text(menu.name),
      ),
      body: FoodDisplay(menu: menu),
    );
  }
}
