import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodiyo/global/global.dart';
import 'package:foodiyo/models/user_cart.dart';
import 'package:foodiyo/widgets/custom_button.dart';
import 'package:foodiyo/widgets/error_dialog.dart';
import 'package:foodiyo/widgets/snackbar.dart';
import 'package:foodiyo/widgets/text_field.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class CustCart extends StatelessWidget {
  const CustCart({Key? key, required this.context}) : super(key: key);
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cart'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/burger knife.png'),
                fit: BoxFit.fill)),
        child: StreamBuilder<List<Cart>>(
          stream: readCart(sharedPreferences!.get('name').toString() + " Cart"),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              final cartItem = snapshot.data!;
              return (cartItem.isNotEmpty)
                  ? ListView(
                      children: cartItem.map(buildCart).toList(),
                    )
                  : const Center(
                      child: Text(
                        'Cart Is Empty',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 50),
                      ),
                    );
            } else {
              return const Text('Something has happened');
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /*Navigator.pop(context);
          showDialog(
              context: context,
              builder: (context) => MyErrorDialog(
                  msg:
                      'Order has been placed.\n\nDelivery guy will call you after collecting your order items'),
              barrierColor: Colors.white.withOpacity(0.2));*/
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Question(),
              ));
        },
        child: const SizedBox(
          child: Icon(
            Icons.shopping_cart_checkout,
            color: Colors.amber,
          ),
          width: 200,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget buildCart(Cart cart) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.amber.withOpacity(0.8),
      ),
      height: 150,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(cart.photoURL),
              radius: 55),
          const SizedBox(
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cart.name,
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
                    cart.veg.toUpperCase() == 'VEG'
                        ? Image.asset(
                            'images/veg.png',
                            height: 30,
                          )
                        : Image.asset(
                            'images/non_veg.png',
                            height: 30,
                          ),
                    Text(
                      'Rs.${cart.price}',
                      style: const TextStyle(fontSize: 15),
                      textAlign: TextAlign.start,
                    ),
                    IconButton(
                        onPressed: () {
                          final docUser = FirebaseFirestore.instance
                              .collection(
                                  sharedPreferences!.get('name').toString() +
                                      ' Cart')
                              .doc(cart.id);
                          docUser.delete();
                        },
                        icon: const Icon(Icons.delete))
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class Question extends StatelessWidget {
  Question({Key? key}) : super(key: key);
  Offset distance = const Offset(5, 5);
  double blur = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/burger knife.png'),
                fit: BoxFit.fitHeight)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Proceed with address in your profile?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 50,
            ),

            //button1
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (context) => MyErrorDialog(
                        msg:
                            'Order has been placed.\n\nDelivery guy will call you after collecting your order items'),
                    barrierColor: Colors.white.withOpacity(0.2));
              },
              child: Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          offset: -distance,
                          color: Colors.black,
                          blurRadius: blur),
                      BoxShadow(
                          offset: distance,
                          color: Colors.black,
                          blurRadius: blur)
                    ],
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(30)),
                child: const Center(
                  child: Text('Yes',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
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

            //button2
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddressEnter(),
                  )),
              child: Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          offset: -distance,
                          color: Colors.black,
                          blurRadius: blur),
                      BoxShadow(
                          offset: distance,
                          color: Colors.black,
                          blurRadius: blur)
                    ],
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(30)),
                child: const Center(
                  child: Text('No',
                      style:
                          const TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}

class AddressEnter extends StatelessWidget {
  AddressEnter({Key? key}) : super(key: key);

  TextEditingController locationController = TextEditingController();

  Position? pos;
  List<Placemark>? placemarkList;
  String newCompleteAddress = "";

  getCurrentLocation() async {
    await Geolocator.requestPermission();
    Position newposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    pos = newposition;
    placemarkList =
        await placemarkFromCoordinates(pos!.latitude, pos!.longitude);
    Placemark pmarkList = placemarkList![0];

    newCompleteAddress =
        '${pmarkList.name}, ${pmarkList.locality}, ${pmarkList.subAdministrativeArea}, ${pmarkList.administrativeArea}, ${pmarkList.postalCode}, ${pmarkList.country}';

    locationController.text = newCompleteAddress;
  }

  submitValidation(BuildContext context) async {
    final location = locationController.text;
    if (location.isEmpty) {
      callCustomSnackbar(context, 'Please Enter The Address!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/burger knife.png'),
              fit: BoxFit.fitHeight),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 200),
          child: Column(
            children: [
              const Text(
                'Delivery Address',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.amber,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 50,
              ),
              CustomTextField(
                textInputType: TextInputType.text,
                txt: locationController,
                hintText: 'Address',
                iconData: Icons.location_on_outlined,
                isObscure: false,
                enabled: true,
              ),
              ElevatedButton.icon(
                label: Text('Detect Address'),
                icon: const Icon(Icons.location_on_outlined),
                onPressed: () {
                  getCurrentLocation();
                },
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  submitValidation(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) => MyErrorDialog(
                          msg:
                              'Order has been placed.\n\nDelivery guy will call you after collecting your order items'),
                      barrierColor: Colors.white.withOpacity(0.2));
                },
                icon: const Icon(Icons.check),
                style: ElevatedButton.styleFrom(
                    primary: Colors.amber, onPrimary: Colors.black),
                label: const Text(
                  'Submit',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
