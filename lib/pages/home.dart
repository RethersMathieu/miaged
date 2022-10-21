import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:miaged/firebase/auth.dart';

import '../firebase_options.dart';
import 'log.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Home'),),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Center(),
      )
    );
  }
}