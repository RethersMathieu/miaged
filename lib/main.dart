import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase/auth.dart';
import 'firebase_options.dart';
import 'models/profile.dart';
import 'router.dart';

Future<void> main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Auth.userChange().listen((user) async {
    if (user is User) {
      var doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.data() != null) Auth.profilUser = ProfilUser.fromJSON(doc.data()!);
      return;
    }
    Auth.profilUser = null;
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MIAGED',
      routerConfig: RouteConfig.instance,
      debugShowCheckedModeBanner: false,
    );
  }
}