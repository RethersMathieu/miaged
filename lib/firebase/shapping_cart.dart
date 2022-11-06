import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miaged/models/shapping_cart.dart';

import '../models/clothe.dart';
import 'auth.dart';

class ShappingCartService {
  static Future<ShappingCart> getShappingCart() async {
    var shappingCartDoc = await FirebaseFirestore.instance.collection('shapping_carts').doc(Auth.profilUser.shapping_cart).get();
    if (shappingCartDoc.data() != null) {
      var refClothes = shappingCartDoc.data()!['clothes'] as List<DocumentReference<Map<String, dynamic>>>;
      List<Clothe> clothes = [];
      for (var docRefClothe in refClothes) {
        clothes.add(Clothe.fromJson(docRefClothe.id, (await docRefClothe.get()).data()!));
      }
      return ShappingCart(shappingCartDoc.id, clothes);
    }
    await createShappingCart();
    return await getShappingCart();
  }

  static Future<String> createShappingCart() async {
    var shappingCartCollection = FirebaseFirestore.instance.collection('shapping_carts');
    var idShappingCart = Auth.profilUser.shapping_cart;
    if (idShappingCart == null) {
      var doc = await shappingCartCollection.add({ 'clothes': [] });
      await FirebaseFirestore.instance.collection('user').doc(Auth.profilUser.userData?.uid).update({ 'shapping_cart': doc.id });
      return doc.id;
    }
    await shappingCartCollection.doc(idShappingCart).set({ 'clothes': [] });
    return idShappingCart;
  }
}