import 'package:cloud_firestore/cloud_firestore.dart';

class Menu {
  String? id;
  String name;
  String price;
  String veg;
  String photoURL;
  String description;
  String ingredient1;
  String? ingredient2;
  String? ingredient3;

  Menu({
    this.id,
    required this.description,
    required this.photoURL,
    required this.name,
    required this.price,
    required this.veg,
    required this.ingredient1,
    this.ingredient2,
    this.ingredient3,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': photoURL,
      'description': description,
      'name': name,
      'price': price,
      'veg': veg,
      'ingredient1' : ingredient1,
      'ingredient2' : ingredient2,
      'ingredient3' : ingredient3,
    };
  }

  static Menu fromJson(Map<String, dynamic> json) => Menu(
        description: json['description'],
        photoURL: json['image'],
        name: json['name'],
        price: json['price'],
        veg: json['veg'],
        id: json['id'],
        ingredient1: json['ingredient1'],
        ingredient2: json['ingredient2'],
        ingredient3: json['ingredient3'],
      );
}

Stream<List<Menu>> readMenu(String collection) => FirebaseFirestore.instance
    .collection(collection)
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Menu.fromJson(doc.data())).toList());
