import 'clothe.dart';

class ShappingCart {
  late final String id;
  late Set<Clothe> clothes;

  ShappingCart(this.id, Iterable<Clothe>? clothes) {
    this.clothes = clothes != null ? Set.from(clothes) : <Clothe>{};
  }

  ShappingCart.fromJson(String id, Map<String, Object?> json): this(id, json['clothes'] as Iterable<Clothe>);

  Map<String, Object?> toJson() {
    return { 'clothes': clothes.toList() };
  }

  int get size {
    return clothes.length;
  }

  double get totalPrice {
    return clothes
      .map((e) => e.price)
      .reduce((value, n) => value + n);
  }
}