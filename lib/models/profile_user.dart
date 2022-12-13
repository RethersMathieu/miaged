import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilUser {
  late String _adress;
  late String _city;
  late String _zipcode;
  late DocumentReference<Map<String, dynamic>> _shapping_cart_ref;

  ProfilUser({ required String adress, required String city, required String zipcode, required DocumentReference<Map<String, dynamic>> shapping_cart_ref}) {
    _adress = adress;
    _city = city;
    _zipcode = zipcode;
    _shapping_cart_ref = shapping_cart_ref;
  }

  ProfilUser.fromJSON(Map<String, Object?> json): this(
    adress: json['adress'] as String,
    city: json['city'] as String,
    zipcode: json['zipcode'] as String,
    shapping_cart_ref: json['shapping_cart'] as DocumentReference<Map<String, dynamic>>
  );

  String? get login => userData?.email;

  String get adress => _adress;

  String get city => _city;

  String get zipcode => _zipcode;

  DocumentReference<Map<String, dynamic>> get shapping_cart_ref => _shapping_cart_ref;

  User? get userData {
    return FirebaseAuth.instance.currentUser;
  }

  bool get isLogged {
    return userData != null;
  }
}