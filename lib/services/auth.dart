import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/profile_user.dart';


class Auth {

  static ProfilUser? profilUser;

  static Future<dynamic> register({
    required String email,
    required String password,
    required String adress,
    required String city,
    required String zipcode,
    void Function(dynamic)? callback,
  }) async {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore store = FirebaseFirestore.instance;
      dynamic reponse;
      try {
        var doc = await store.collection('shapping_carts').add({ 'clothes': [] });
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
        await store.collection('users')
            .doc(userCredential.user!.uid)
            .set({
              'adress': adress,
              'city': city,
              'zipcode': zipcode,
              'shapping_cart': doc,
              'clothes': [],
            });
      } on FirebaseAuthException catch (e) {
        reponse = e;
      } on FirebaseException catch (e) {
        reponse = e;
      }
      if(callback != null) callback(reponse);
      return reponse;
  }

  static Future<dynamic> signIn({
    required String email,
    required String password,
    void Function(dynamic)? callback,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    dynamic reponse;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      reponse = userCredential.user;
      if (reponse is User) {
        var doc = await FirebaseFirestore.instance.collection('users').doc(reponse.uid).get();
        if (doc.data() != null) Auth.profilUser = ProfilUser.fromJSON(doc.data()!);
      } else {
        Auth.profilUser = null;
      }
    } on FirebaseAuthException catch (e) {
      reponse = e;
    }
    if (callback != null) callback(reponse);
    return reponse;
  }

  static Future<bool> signOut(void Function(bool)? callback) async {
    var success = false;
    try {
      await FirebaseAuth.instance.signOut();
      profilUser = null;
      success = true;
    } on Exception catch (e) {
      if (kDebugMode) { print(e); }
      success = false;
    }
    if (callback != null) callback(success);
    return success;
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