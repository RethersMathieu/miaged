import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:miaged/firebase/auth.dart';

import '../components/card_clothe.dart';
import '../models/clothe.dart';

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

  Widget _initGridView(List<dynamic> docRefClothes) {
    return GridView.builder(
        itemCount: docRefClothes.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
        itemBuilder: (context, index) {
          DocumentReference<Map<String, dynamic>> docRefClothe = docRefClothes[index];
          return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: docRefClothe.snapshots(),
            builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
              var doc = snapshot.data;
              return CardClothe(
                clothe: doc != null ? Clothe.fromJson(doc.id, doc.data()!) : null,
                onTap: (clothe) => clothe != null ? GoRouter.of(context).go('/showcase/clothe/${clothe.id}') : null,
              );
            },
          );
        }
    );
  }

  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> _initStream() {
    return StreamBuilder(
      stream: Auth.profilUser!.shapping_cart_ref.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) return Text('Erreur lors du panier : ${snapshot.error}');
        else if (snapshot.connectionState == ConnectionState.none) return const Text('Non connecté à la base de donnée.');
        else if (snapshot.connectionState == ConnectionState.waiting) return _initSpinner();
        if (snapshot.hasData) {
          var docRefClothes = snapshot.data!.data()!['clothes'];
          var priceTotal = snapshot.data!.data()!['total'] as double;
          if (docRefClothes.length <= 0) return const Text("Panier vide");
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2.5),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black, width: 1.0)
                  )
                ),
                child: Center(
                  child: Text('Total : ${priceTotal.toStringAsFixed(2)}€'),
                ),
              ),
              _initGridView(docRefClothes),
            ],
          );
        }
        return const Text("Panier vide");
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