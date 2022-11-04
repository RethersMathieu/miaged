import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Auth {

  static final profilUser = _ProfilUser();

  static Future<dynamic> register({
    required String email,
    required String password,
    required String adress,
    required String city,
    required String zipcode,
  }) async {
      FirebaseAuth auth = FirebaseAuth.instance;
      dynamic reponse;
      try {
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
              'adress': adress,
              'city': city,
              'zipcode': zipcode,
            });
      } on FirebaseAuthException catch (e) {
        reponse = e;
      } on FirebaseException catch (e) {
        reponse = e;
      }
      return reponse;
  }

  static Future<dynamic> signIn({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    dynamic reponse;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      reponse = userCredential.user;
    } on FirebaseAuthException catch (e) {
      reponse = e;
    }
    return reponse;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<User?> refresh(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await user.reload();
    User? refreshedUser = auth.currentUser;
    return refreshedUser;
  }

  static Stream<User?> userChange() {
    return FirebaseAuth.instance.userChanges();
  }
}

class _ProfilUser {
  Map<String, dynamic>? data;

  _ProfilUser() {
    Auth.userChange().listen((user) async {
      if (user is User) {
        var doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        data = doc.data();
        if (data != null) {
          (data!['shapping_cart'] as DocumentReference<Map<String, dynamic>>).get().then((value) => print(value['total_price']));
        }
        return;
      }
      data = null;
    });
  }

  String? get login {
    return userData?.email;
  }

  String? get adress {
    return data!['adress'];
  }

  String? get city {
    return data!['city'];
  }

  String? get zipcode {
    return data!['zipcode'];
  }

  User? get userData {
    return FirebaseAuth.instance.currentUser;
  }

  bool get isLogged {
    return userData != null;
  }

}