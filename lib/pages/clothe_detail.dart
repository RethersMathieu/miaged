import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:miaged/services/cart_service.dart';

import '../models/clothe.dart';

class ClotheDetail extends StatelessWidget {
  final fontColor = Colors.blue.shade700;
  final String id;

  ClotheDetail({super.key, required this.id });

  Widget _initSpinner() {
    return const Center(
      child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator()),
    );
  }

  Widget _topDetail(BuildContext context, Clothe clothe) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 10.0),
          height: MediaQuery.of(context).size.height * .5,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(clothe.img),
              fit: BoxFit.cover,
            )
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * .5,
          padding: const EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: Container()),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        clothe.name,
                          style: TextStyle(
                            color: fontColor,
                            fontSize: 35.0,
                          )
                      ),
                      Container(
                        padding: const EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: fontColor),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text("${clothe.price} €", style: TextStyle(color: fontColor)),
                      )
                    ],
                  )
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 8.0,
          top: 8.0,
          child: InkWell(
            onTap: () => GoRouter.of(context).pop(),
            child: Icon(Icons.arrow_back, color: fontColor),
          ),
        )
      ],
    );
  }

  Widget _bottomDetails(BuildContext context, Clothe clothe) {
    var textStyle = TextStyle(fontSize: 20.0, color: fontColor);
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Taille: ${clothe.size}", style: textStyle),
          Text("Categorie: ${clothe.category}", style: textStyle),
        ],
      ),
    );
  }

  Widget _details(BuildContext context, Clothe clothe) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
              children: [
                _topDetail(context, clothe),
                _bottomDetails(context, clothe),
              ]
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * .5 - 25,
            right: 15.0,
            child: ElevatedButton(
              onPressed: () async {
                if (await CartService.addClothe(clothe)) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "\"${clothe.name}\" Ajouter au panier",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    duration: const Duration(seconds: 3),
                    backgroundColor: Colors.blue[400],
                  ));
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                    "Erreur d'ajout au panier.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                ));
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all(const CircleBorder()),
                padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                foregroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 50),
            ),
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('clothes').doc(id).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Text('Erreur lors du chargement de la page : ${snapshot.error}');
        } else if (snapshot.connectionState == ConnectionState.none) {
          return const Text('Non connecté à la base de donnée.');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return _initSpinner();
        }
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