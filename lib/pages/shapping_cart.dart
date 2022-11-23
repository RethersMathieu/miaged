import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miaged/firebase/auth.dart';

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
              var doc = snapshot.data!;
              var clothe = Clothe.fromJson(doc.id, doc.data()!);
              return GestureDetector(
                onTap: () => print('Clothe ${clothe.id} tapped.'),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    width: (MediaQuery.of(context).size.width/2)-15,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: const BorderRadius.all(Radius.circular(0.0)),
                      image: DecorationImage(
                        image: NetworkImage(clothe.img),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child:  Padding(
                      padding: const EdgeInsets.all(0),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          gradient: LinearGradient(
                              colors: [Colors.black, Color(0x19000000)],
                              begin: FractionalOffset(0.0, 1.0),
                              end: FractionalOffset(0.0, 0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${clothe.name[0].toUpperCase()}${clothe.name.substring(1).toLowerCase()}',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.white),
                              ),
                              Text(
                                '${clothe.price.toStringAsFixed(2)}€',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w200,
                                    color: Colors.white
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ), /* add child content here */
                  ),
                ),
              );
            },
          );
        }
    );
  }

  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> _initStream() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('shapping_carts').doc(Auth.profilUser.shapping_cart).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) return Text('Erreur lors du panier : ${snapshot.error}');
        else if (snapshot.connectionState == ConnectionState.none) return const Text('Non connecté à la base de donnée.');
        else if (snapshot.connectionState == ConnectionState.waiting) return _initSpinner();
        if (snapshot.hasData) {
          var docRefClothes = snapshot.data!.data()!['clothes'];
          return _initGridView(docRefClothes);
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