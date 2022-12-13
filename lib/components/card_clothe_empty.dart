import 'package:flutter/material.dart';

class CardClotheEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
            width: (MediaQuery.of(context).size.width/2)-15,
            height: 150,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(0.0)),
              gradient: LinearGradient(
                  colors: [Colors.black, Color(0x19000000)],
                  begin: FractionalOffset(0.0, 1.0),
                  end: FractionalOffset(0.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp
              ),
            )
        ),
      ),
    );
  }

}