import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miaged/services/auth.dart';

import '../models/clothe.dart';

class ClotheService {
  static final _users = FirebaseFirestore.instance.collection("users");
  static final _clothes = FirebaseFirestore.instance.collection("clothes");

  static Future<bool> addClothe(Clothe clothe) async {
    var map = clothe.toJson();
    var profil = Auth.profilUser;
    try {
      if (profil != null) {
        var doc = await _clothes.add(map);
        await _users.doc(profil.userData?.uid).update({ "clothes": FieldValue.arrayUnion([doc]) });
        profil.clothes_ref.add(doc);
        return true;
      }
      return false;
    } on Exception {
      return false;
    }
  }
}