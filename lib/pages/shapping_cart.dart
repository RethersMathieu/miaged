import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:miaged/services/auth.dart';
import 'package:miaged/services/cart_service.dart';

import '../components/card_clothe.dart';
import '../models/clothe.dart';

class ShappingCart extends StatefulWidget {
  const ShappingCart({ super.key });

  @override
  State<ShappingCart> createState() => _SappingCartState();
}

class _SappingCartState extends State<ShappingCart> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Stream<double> _streamGetPriceTotal() {
    return Auth.profilUser!.shappingCartRef.snapshots()
        .asyncMap((snapshot) {
          List refs = snapshot.data()?['clothes'] ?? [];
          return Future.wait(refs.map((e) => (e as DocumentReference<Map<String, dynamic>>).get()));
        })
        .map((event) => event.map((e) => e.data() != null ? e.data()!["price"] as double : 0.0))
        .map((event) => event.isNotEmpty ? event.reduce((value, element) => value + element) : 0.0);
  }

  Widget _initSpinner() {
    return const Center(
      child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator()),
    );
  }

  void removeClothe(Clothe clothe) {
    CartService.removeClothe(
      clothe,
      callback: (sucess) {
        if (sucess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
              "Suppression réussie",
              style: TextStyle(
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
            "Erreur suppression.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ));
      }
    );
  }

  Widget _initGridView(List<dynamic> docRefClothes) {
    return GridView.builder(
        itemCount: docRefClothes.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (itemContext, index) {
          DocumentReference<Map<String, dynamic>> docRefClothe = docRefClothes[index];
          return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: docRefClothe.snapshots(),
            builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
              var doc = snapshot.data;
              var oClothe = doc != null ? Clothe.fromJson(doc.id, doc.data()!) : null;
              return CardClothe(
                clothe: oClothe,
                onTap: (clothe) => clothe != null ? GoRouter.of(context).go('/shapping_cart/clothe/${clothe.id}') : null,
                onCross: (clothe) async {
                  await showDialog<bool>(
                      context: ctx,
                      builder: (BuildContext buildContext) => AlertDialog(
                        title: const Text("Suppression"),
                        content: Text("Êtes-vous sûr de vouloir supprimer le \"${clothe.name}\" du panier ?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(buildContext, false),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.blue),
                              foregroundColor: MaterialStateProperty.all(Colors.blue),
                            ),
                            child: const Text("Non", style: TextStyle(color: Colors.white))
                          ),
                          TextButton(
                            onPressed: () {
                              removeClothe(clothe);
                              Navigator.pop(buildContext, true);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.white),
                              foregroundColor: MaterialStateProperty.all(Colors.white),
                            ),
                            child: const Text("Oui", style: TextStyle(color: Colors.blue)))
                        ],
                      )
                  );

                },
              );
            },
          );
        }
    );
  }

  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> _initStream() {
    return StreamBuilder(
      stream: Auth.profilUser!.shappingCartRef.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Text('Erreur lors du panier : ${snapshot.error}');
        } else if (snapshot.connectionState == ConnectionState.none) {
          return const Text('Non connecté à la base de donnée.');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return _initSpinner();
        }
        if (snapshot.hasData) {
          var docRefClothes = snapshot.data!.data()!['clothes'];
          if (docRefClothes.length <= 0) return const Text("Panier vide");
          return _initGridView(docRefClothes);
        }
        return const Text("Panier vide");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: const Text('Panier')),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: _initStream()
            ),
            Expanded(
              flex: 1,
              child:
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2.5),
                decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.black, width: 1.0)
                    )
                ),
                child: Center(
                  child: StreamBuilder<double>(
                    stream: _streamGetPriceTotal(),
                    builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                      var price = snapshot.hasData ? snapshot.data! : 0.0;
                      return Text('Total : ${price.toStringAsFixed(2)}€');
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}