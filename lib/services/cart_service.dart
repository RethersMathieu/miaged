import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/clothe.dart';
import 'auth.dart';

class CartService {

  static Future<bool> addClothe(Clothe clothe) async {
    final profilUser = Auth.profilUser;
    if (profilUser != null) {
      try {
        var shappingCartRef = profilUser.shappingCartRef;
        var docClotheRef = FirebaseFirestore.instance.collection("clothes").doc(clothe.id);
        await shappingCartRef.update({ "clothes": FieldValue.arrayUnion([docClotheRef]) });
        return true;
      } on Exception catch (e) {
        if (kDebugMode) {
          print(e);
        }
        return false;
      }
    }
    return false;
  }

  static Future<bool> removeClothe(Clothe clothe, { void Function(bool)? callback }) async {
    final profilUser = Auth.profilUser;
    var success = false;
    if (profilUser != null) {
      try {
        var shappingCartRef = profilUser.shappingCartRef;
        var docClotheRef = FirebaseFirestore.instance.collection("clothes").doc(clothe.id);
        await shappingCartRef.update({ "clothes": FieldValue.arrayRemove([docClotheRef]) });
        success = true;
      } on Exception catch (e) {
        if (kDebugMode) {
          print(e);
        }
        success = false;
      }
    }
    if (callback != null) callback(success);
    return success;
  }
}