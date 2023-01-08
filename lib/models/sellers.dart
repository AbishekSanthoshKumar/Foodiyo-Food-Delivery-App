import 'package:cloud_firestore/cloud_firestore.dart';

class Sellers {
  String? id;
  String name;
  String email;
  String phone;
  String location;
  String photoURL;

  Sellers({
    this.id,
    required this.photoURL,
    required this.name,
    required this.email,
    required this.location,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'photo': photoURL,
      'name': name,
      'email': email,
      'location': location,
      'phone': phone,
    };
  }

  static Sellers fromJson(Map<String, dynamic> json) => Sellers(
        photoURL: json['photo'],
        name: json['name'],
        email: json['email'],
        location: json['location'],
        phone: json['phone'],
      );
}

Stream<List<Sellers>> readSeller(String collection) => FirebaseFirestore.instance
    .collection(collection)
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Sellers.fromJson(doc.data())).toList());
