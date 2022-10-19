import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';
import 'log.dart';

class Home extends StatelessWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context) {

    Future<FirebaseApp> _initializeFirebase() async {
      FirebaseApp firebaseApp =  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LogIn(),
          ),
        );
      }
      return firebaseApp;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Home'),),
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.all(20),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      )
    );
  }
}