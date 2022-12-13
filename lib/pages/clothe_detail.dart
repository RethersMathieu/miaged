import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:miaged/components/cart_badge.dart';

import '../models/clothe.dart';

class ClotheDetail extends StatelessWidget {
  final String id;
  const ClotheDetail({super.key, required this.id });

  Widget _initSpinner() {
    return const Center(
      child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator()),
    );
  }

  Widget _details(BuildContext context, Clothe clothe) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 500,
                child: Image.network(clothe.img, fit: BoxFit.cover,),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(Icons.arrow_back, color: Colors.black)
                      ),
                      const CartBadge(),
                    ],
                  ),
                )
              )
            ],
          ),
          Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1.0, color: Colors.grey),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          child: Text(
                            clothe.name.toUpperCase(),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Text(
                            'Taille : ${clothe.size}',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Text(
                            '${clothe.price}€',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('clothes').doc(id).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) return Text('Erreur lors du chargement de la page : ${snapshot.error}');
        else if (snapshot.connectionState == ConnectionState.none) return const Text('Non connecté à la base de donnée.');
        else if (snapshot.connectionState == ConnectionState.waiting) return _initSpinner();
        if (snapshot.hasData) {
          var jsonClothe = snapshot.data?.data();
          if (jsonClothe == null) return const Text("Vêtement indosponible");
          return _details(context ,Clothe.fromJson(id, jsonClothe));
        }
        return const Text("Vêtement indosponible");
      },
    );
  }

}