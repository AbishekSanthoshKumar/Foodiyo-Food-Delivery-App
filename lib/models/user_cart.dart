import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  String? id;
  String name;
  String price;
  String veg;
  String photoURL;

  Cart({
    this.id,
    required this.photoURL,
    required this.name,
    required this.price,
    required this.veg,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': photoURL,
      'name': name,
      'price': price,
      'veg': veg,
    };
  }

  static Cart fromJson(Map<String, dynamic> json) => Cart(
        photoURL: json['image'],
        name: json['name'],
        price: json['price'],
        veg: json['veg'],
        id: json['id'],
      );
}

Stream<List<Cart>> readCart(String collection) => FirebaseFirestore.instance
    .collection(collection)
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Cart.fromJson(doc.data())).toList());
