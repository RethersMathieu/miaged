import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miaged/firebase/auth.dart';
import 'package:miaged/firebase/shapping_cart.dart';

class ShappingCart extends StatefulWidget {
  const ShappingCart({ super.key });

  @override
  State<ShappingCart> createState() => _SappingCartState();
}

class _SappingCartState extends State<ShappingCart> {

  Widget _initSpinner() {
    return const Center(
      child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator()),
    );
  }

  FutureBuilder<ShappingCart> _initStream() {
    return FutureBuilder(
      future: ShappingCartService.getShappingCart() as Future<ShappingCart>?,
      builder: (BuildContext context, AsyncSnapshot<ShappingCart> snapshot) {
        if (snapshot.hasError) return Text('Erreur lors du panier : ${snapshot.error}');
        else if (snapshot.connectionState == ConnectionState.none) return const Text('Non connecté à la base de donnée.');
        else if (snapshot.connectionState == ConnectionState.waiting) return _initSpinner();
        if (snapshot.hasData && snapshot.data != null) {
          var shappingCart = snapshot.data!;
        }
        return const Text("Aucun vêtements disponible dans le panier");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panier')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _initStream(),
      ),
    );
  }
}