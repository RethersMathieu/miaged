import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/clothe.dart';
import 'auth.dart';

class CartService {

  static Future<bool> addClothe(Clothe clothe) async {
    final profilUser = Auth.profilUser;
    if (profilUser != null) {
      try {
        var shapping_cart_ref = profilUser.shapping_cart_ref;
        var docClotheRef = FirebaseFirestore.instance.collection("clothes").doc(clothe.id);
        await shapping_cart_ref.update({ "clothes": FieldValue.arrayUnion([docClotheRef]) });
        return true;
      } on Exception catch (e) {
        print(e);
        return false;
      }
    }
    return false;
  }

  static Future<bool> removeClothe(Clothe clothe) async {
    final profilUser = Auth.profilUser;
    if (profilUser != null) {
      try {
        var shapping_cart_ref = profilUser.shapping_cart_ref;
        var docClotheRef = FirebaseFirestore.instance.collection("clothes").doc(clothe.id);
        await shapping_cart_ref.update({ "clothes": FieldValue.arrayRemove([docClotheRef]) });
        return true;
      } on Exception catch (e) {
        print(e);
        return false;
      }
    }
    return false;
  }
}