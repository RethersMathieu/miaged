import 'package:flutter/material.dart';
import 'package:miaged/components/card_clothe_empty.dart';

import '../models/clothe.dart';

class CardClothe extends StatefulWidget {
  Clothe? clothe;
  void Function(Clothe? clothe)? onTap;
  void Function(Clothe clothe)? onCross;
  CardClothe({ required this.clothe, this.onTap, this.onCross });

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
          width: 150,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        if (widget.onCross != null) ClipOval(
                          child: Material(
                            color: Colors.white, // Button color
                            child: InkWell(
                              splashColor: Colors.red, // Splash color
                              onTap: () => widget.onCross!(widget.clothe!),
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
                          '${widget.clothe!.name[0].toUpperCase()}${widget.clothe!.name.substring(1).toLowerCase()}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.white),
                          maxLines: 1,
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
                ],
              )
            ),
          ), /* add child content here */
        ),
      ),
    );
  }

}