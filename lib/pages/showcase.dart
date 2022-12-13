import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:miaged/components/card_clothe.dart';
import 'package:miaged/models/clothe.dart';

class Showcase extends StatefulWidget {
  const Showcase({ super.key });

  @override
  State<Showcase> createState() => _ShowcaseState();
}

class _ShowcaseState extends State<Showcase> {

  Widget _initSpinner() {
    return const Center(
      child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator()),
    );
  }

  Widget _initGridViewClothes(List<Clothe> clothes) {
      return GridView.builder(
        itemCount: clothes.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          var clothe = clothes[index];
          return CardClothe(
            clothe: clothe,
            onTap: (clothe) => GoRouter.of(context).go('/showcase/clothe/${clothe!.id}'),
          );
        },
      );
  }

  StreamBuilder<QuerySnapshot> _initStream() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('clothes').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Erreur lors du chargement des vetements : ${snapshot.error}');
        else if (snapshot.connectionState == ConnectionState.none) return const Text('Non connecté à la base de donnée.');
        else if (snapshot.connectionState == ConnectionState.waiting) return _initSpinner();
        if (snapshot.hasData) {
          var clothes = snapshot.data!.docs.map((e) => Clothe.fromJson(e.id, e.data() as Map<String, dynamic>)).toList();
          return _initGridViewClothes(clothes);
        }
        return const Text("Aucun vêtements disponible");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acheter')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _initStream(),
      ),
    );
  }
}