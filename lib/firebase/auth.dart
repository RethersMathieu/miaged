import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Auth {

  static final profilUser = _ProfilUser();

  static Future<dynamic> register({
    required String email,
    required String password,
  }) async {
      FirebaseAuth auth = FirebaseAuth.instance;
      dynamic reponse;
      try {
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
        reponse = userCredential.user;
      } on FirebaseAuthException catch (e) {
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
      print(user);
      if (user is User) {
        var doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        data = doc.data();
        return;
      }
      data = null;
    });
  }

  String? get lastname {
    return data!['lastname'];
  }

  String? get firstname {
    return data!['firstname'];
  }

  String? get adress {
    return data!['adress'];
  }

  String? get city {
    return data!['city'];
  }

  User? get userData {
    return FirebaseAuth.instance.currentUser;
  }

  bool get isLogged {
    return userData != null;
  }

}