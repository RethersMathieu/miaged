class Clothe {
  final String id;
  String img;
  String name;
  String size;
  double price;
  String category;

  Clothe({ required this.id, required this.img, required this.name, required this.size, required this.price, required this.category});

  Clothe.fromJson(String id, Map<String, Object?> json): this(
    id: id,
    img: json['image']! as String,
    name: json['name']! as String,
    size: json['size']! as String,
    price: json['price']! as double,
    category: json['category'] as String,
  );

  Map<String, Object?> toJson() {
    return {
      'image': img,
      'name': name,
      'size': size,
      'price': price,
      'category': category,
    };
  }

  @override
  String toString() {
    return 'Clothe($id, $img, $name, $size, $price, $category)';
  }
}