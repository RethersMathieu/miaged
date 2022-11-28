import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
          return GestureDetector(
            onTap: () => GoRouter.of(context).go('/showcase/clothe/${clothe.id}'),
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