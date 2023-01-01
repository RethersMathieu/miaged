import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilUser {
  final String adress;
  final String city;
  final String zipcode;
  final DocumentReference<Map<String, dynamic>> shappingCartRef;
  final List<dynamic> clothesRef;

  ProfilUser({
    required this.adress,
    required this.city,
    required this.zipcode,
    required this.shappingCartRef,
    required this.clothesRef
  });

  ProfilUser.fromJSON(Map<String, Object?> json): this(
    adress: json['adress'] as String,
    city: json['city'] as String,
    zipcode: json['zipcode'] as String,
    shappingCartRef: json['shapping_cart'] as DocumentReference<Map<String, dynamic>>,
    clothesRef: json['clothes'] as List<dynamic>,
  );

  String? get login => userData?.email;

  User? get userData {
    return FirebaseAuth.instance.currentUser;
  }

  bool get isLogged {
    return userData != null;
  }

  @override
  String toString() {
    return "ProfilUser($login, $adress, $city, $zipcode)";
  }
}