import 'dart:async';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class Auth {
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
}