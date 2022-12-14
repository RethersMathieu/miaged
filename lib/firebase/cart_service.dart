import '../models/clothe.dart';
import 'auth.dart';

class CartService {

  static Future<void> addClothe(Clothe clothe) async {

  }

  static Future<bool> removeClothe(Clothe clothe) async {
    final profilUser = Auth.profilUser;
    if (profilUser != null) {
      try {
        var doc = (await profilUser.shapping_cart_ref.get()).data();
        if (doc == null) return false;
        var clothesRef = doc['clothes'] as List<dynamic>;
        var totalPrice = doc['total'] as double;
        print(clothesRef);
        print(totalPrice);
        clothesRef = clothesRef.where((docRef) => docRef.id != clothe.id).toList();
        print(clothesRef);
        if (clothesRef.isNotEmpty) {
          totalPrice = await clothesRef.map((docRef) async => (await docRef.get()).data()!['price'] as double).reduce((value, element) async => (await value) + (await element));
          totalPrice = totalPrice < 0 ? 0 : totalPrice;
        } else totalPrice = 0;
        print(totalPrice);
        await profilUser.shapping_cart_ref.set({ 'clothes': clothesRef, 'total': totalPrice });
        return true;
      } on Exception catch (e) {
        print(e);
        return false;
      }
    }
    return false;
  }
}