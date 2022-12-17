import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/auth.dart';

class CartBadge extends StatefulWidget {
  const CartBadge({ super.key });

  @override
  State<StatefulWidget> createState() => _CartBadgeState();
}

class _CartBadgeState extends State<CartBadge> {

  IconButton _iconButton(BuildContext context) => IconButton(
      onPressed: () => GoRouter.of(context).go('/shapping_cart'),
      icon: const Icon(Icons.shopping_basket, color: Colors.black)
  );

  @override
  Widget build(BuildContext context) {
    if (Auth.profilUser == null) return _iconButton(context);
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: Auth.profilUser!.shapping_cart_ref.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          var docRefClothes = snapshot.data!.data()!['clothes'];
          return Badge(
              position: const BadgePosition(end: 1.0, top: 1.0),
              badgeContent: Text('${docRefClothes.length}'),
              child: _iconButton(context),
          );
        }
        return _iconButton(context);
      },
    );
  }

}