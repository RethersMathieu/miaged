import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miaged/clothe.dart';

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
        return Center(
          child: Card(
            child: Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: NetworkImage(clothe.img),
                  fit: BoxFit.cover,
                )
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text('${clothe.name[0].toUpperCase()}${clothe.name.substring(1).toLowerCase()}'),
              ),
            ),
          ),
        )
      },
    );
  }

  StreamBuilder<QuerySnapshot> _initStream() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('clothes').withConverter<Clothe>(
          fromFirestore: (snapshot, _) => Clothe.fromJson(snapshot.data()!),
          toFirestore: (clothe, _) => clothe.toJson(),
      ).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Erreur lors du chargement des vetements : ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.none: return const Text('Non connecté à la base de donnée.');
          case ConnectionState.waiting: return _initSpinner();
          case ConnectionState.done:
            return
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acheter')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
      ),
    );
  }
}