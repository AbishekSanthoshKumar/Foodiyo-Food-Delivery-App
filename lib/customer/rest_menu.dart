import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodiyo/customer/cart.dart';
import 'package:foodiyo/customer/cust_food_display.dart';
import 'package:foodiyo/global/global.dart';
import 'package:foodiyo/main.dart';
import 'package:foodiyo/models/rest_menu.dart';
import 'package:foodiyo/models/sellers.dart';
import 'package:foodiyo/models/user_cart.dart';
import 'package:foodiyo/widgets/snackbar.dart';
import 'package:google_fonts/google_fonts.dart';

class RestMenu extends StatelessWidget {
  const RestMenu({Key? key, required this.seller, required this.loc})
      : super(key: key);
  final Sellers seller;
  final String loc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustCart(
                  context: context,
                ),
              )),
          backgroundColor: Colors.amber,
          child: const Icon(
            Icons.shopping_cart,
            color: Colors.white,
          )),
      appBar: AppBar(
        centerTitle: true,
        title: Text(seller.name),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/detailbgs.jpg'), fit: BoxFit.fill)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.amber.withOpacity(0.8)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 130,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                seller.name,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          backgroundImage: NetworkImage(seller.photoURL),
                          radius: 60,
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on),
                          Text(
                            loc,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Stack(children: [
                      Column(
                        children: [
                          const SizedBox(
                            child: Text('Restaurants'),
                          ),
                          Container(
                            height: 30,
                            color: Colors.blueGrey,
                            width: double.infinity,
                          ),
                          Container(
                            decoration:
                                const BoxDecoration(color: Colors.blueGrey),
                            height: 400,
                            width: double.infinity,
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  height: 390,
                                  child: StreamBuilder<List<Menu>>(
                                    stream: readMenu('${seller.name}_menu'),
                                    builder: (ctx, snapshot) {
                                      if (snapshot.hasData) {
                                        final menu = snapshot.data!;
                                        return ListView(
                                          children:
                                              menu.map(buildMenu).toList(),
                                        );
                                      } else {
                                        return const Text(
                                            'Something has happened');
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(20)),
                        height: 40,
                        width: double.infinity,
                        child: Text(
                          'Restaurants',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.hurricane(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ]),
                    Stack(
                      children: [
                        Container(
                          decoration:
                              const BoxDecoration(color: Colors.blueGrey),
                          width: double.infinity,
                          child: const SizedBox(
                            height: 20,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(20)),
                          width: double.infinity,
                          child: const SizedBox(
                            height: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
                child: Center(
                  child: Text(
                    seller.name + ' Menu',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenu(Menu menu) {
    return GestureDetector(
      onTap: () => Navigator.push(
          NavigationService.navigatorKey.currentContext!,
          MaterialPageRoute(
              builder: ((context) => CustFoodDisplay(menu: menu)))),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white.withOpacity(0.8),
        ),
        height: 150,
        margin: const EdgeInsets.symmetric(vertical: 10),
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
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
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
                      IconButton(
                        onPressed: () {
                          final docUser = FirebaseFirestore.instance
                              .collection(
                                  '${sharedPreferences!.get('name')} Cart')
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
                              NavigationService.navigatorKey.currentContext!,
                              'Added to Cart');
                        },
                        icon: const Icon(Icons.add_shopping_cart),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
