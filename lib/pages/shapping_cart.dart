import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miaged/firebase/auth.dart';

class ShappingCart extends StatefulWidget {
  const ShappingCart({ super.key });

  @override
  State<ShappingCart> createState() => _SappingCartState();
}

class _SappingCartState extends State<ShappingCart> {

  StreamBuilder<QuerySnapshot>? _initStream() {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panier')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
      ),
    );
  }
}