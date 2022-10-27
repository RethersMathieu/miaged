class Clothe {
  String img;
  String name;
  String size;
  double price;

  Clothe({ required this.img, required this.name, required this.size, required this.price});

  Clothe.fromJson(Map<String, Object?> json): this(
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