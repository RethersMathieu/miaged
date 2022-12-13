import 'package:flutter/material.dart';
import 'package:miaged/components/card_clothe_empty.dart';

import '../models/clothe.dart';

class CardClothe extends StatefulWidget {
  Clothe? clothe;
  void Function(Clothe? clothe)? onTap;
  CardClothe({ required this.clothe, this.onTap });

  @override
  State<StatefulWidget> createState() => _CardClotheState();
}

class _CardClotheState extends State<CardClothe> {

  @override
  Widget build(BuildContext context) {
    if (widget.clothe == null) return CardClotheEmpty();
    return GestureDetector(
      onTap: () => { if (widget.onTap != null) widget.onTap!(widget.clothe) },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          width: (MediaQuery.of(context).size.width/2)-15,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(0.0)),
            image: DecorationImage(
              image: NetworkImage(widget.clothe!.img),
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
                      '${widget.clothe!.name[0].toUpperCase()}${widget.clothe!.name.substring(1).toLowerCase()}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.white),
                    ),
                    Text(
                      '${widget.clothe!.price.toStringAsFixed(2)}€',
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
  }

}