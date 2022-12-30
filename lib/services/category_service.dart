import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category.dart';

class CategoryService {
  static final instance = CategoryService._();

  List<Category> _categories = [];
  final stream_categories = FirebaseFirestore.instance
      .collection("categories")
      .snapshots()
      .map((event) => event.docs.map((e) => Category.fromQueryDocument(e)).toList());

  CategoryService._() {
    stream_categories.listen((event) {
      _categories.clear();
      _categories.addAll(event);
    });
  }

  List<Category> get categories {
    return _categories;
  }
}