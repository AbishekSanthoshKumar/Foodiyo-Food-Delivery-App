import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodiyo/global/global.dart';
import 'package:foodiyo/main.dart';
import 'package:foodiyo/models/rest_menu.dart';
import 'package:foodiyo/models/user_cart.dart';
import 'package:foodiyo/widgets/food_display.dart';
import 'package:foodiyo/widgets/snackbar.dart';

class CustFoodDisplay extends StatelessWidget {
  const CustFoodDisplay({Key? key, required this.menu}) : super(key: key);
  final Menu menu;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final docUser = FirebaseFirestore.instance
              .collection('${sharedPreferences!.get('name')} Cart')
              .doc(menu.name);
          final cartItem = Cart(
              photoURL: menu.photoURL,
              name: menu.name,
              price: menu.price,
              veg: menu.veg);

          cartItem.id = docUser.id;
          final json = cartItem.toJson();
          docUser.set(json);
          callCustomSnackbar(
              NavigationService.navigatorKey.currentContext!, 'Added to Cart');
        },
        child: const Icon(Icons.add_shopping_cart),
        backgroundColor: Colors.amber,
      ),
      body: FoodDisplay(menu: menu),
    );
  }
}
