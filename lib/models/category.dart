import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String name;
  Category({ required this.id, required this.name });

  Category.fromQueryDocument(QueryDocumentSnapshot<Map<String, dynamic>> queryDocumentSnapshot): this(
      id: queryDocumentSnapshot.id,
      name: queryDocumentSnapshot.get("name") as String
  );
}