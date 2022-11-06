class Clothe {
  final String id;
  String img;
  String name;
  String size;
  double price;

  Clothe({ required this.id, required this.img, required this.name, required this.size, required this.price});

  Clothe.fromJson(String id, Map<String, Object?> json): this(
    id: id,
    img: json['image']! as String,
    name: json['name']! as String,
    size: json['size']! as String,
    price: json['price']! as double,
  );

  Map<String, Object?> toJson() {
    return {
      'image': img,
      'name': name,
      'size': size,
      'price': price,
    };
  }
}