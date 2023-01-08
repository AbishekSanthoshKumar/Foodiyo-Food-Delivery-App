class Users {
  String? id;
  String name;
  String email;
  String phone;
  String location;
  String photoURL;

  Users({
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
      'photo' : photoURL,
      'name': name,
      'email': email,
      'location': location,
      'phone': phone,
    };
  }
}