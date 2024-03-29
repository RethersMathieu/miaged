import 'package:flutter/material.dart';
import 'package:miaged/components/card_clothe_empty.dart';

import '../models/clothe.dart';

class CardClothe extends StatelessWidget {
  final Clothe? clothe;
  final void Function(Clothe? clothe)? onTap;
  final void Function(Clothe clothe)? onCross;
  const CardClothe({super.key, required this.clothe, this.onTap, this.onCross });

  @override
  Widget build(BuildContext context) {
    if (clothe == null) return const CardClotheEmpty();
    return GestureDetector(
      onTap: () => { if (onTap != null) onTap!(clothe) },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(0.0)),
            image: DecorationImage(
              image: NetworkImage(clothe!.img),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          clothe!.size,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700
                          )
                        ),
                        if (onCross != null) ClipOval(
                          child: Material(
                            color: Colors.white, // Button color
                            child: InkWell(
                              splashColor: Colors.red, // Splash color
                              onTap: () => onCross!(clothe!),
                              child: const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Icon(Icons.close_sharp, color: Colors.black, size: 10.0,)
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${clothe!.name[0].toUpperCase()}${clothe!.name.substring(1).toLowerCase()}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.white),
                          maxLines: 1,
                        ),
                        Text(
                          '${clothe!.price.toStringAsFixed(2)}€',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ),
          ), /* add child content here */
        ),
      ),
    );
  }

}