import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category.dart';

class CategoryService {
  static final instance = CategoryService._();


  final streamCategories = FirebaseFirestore.instance
      .collection("categories")
      .snapshots()
      .map((event) => event.docs.map((e) => Category.fromQueryDocument(e)).toList());

  final futureCategories = FirebaseFirestore.instance
    .collection("categories")
    .get()
    .then((value) => value.docs)
    .then((value) => value.map((e) => Category.fromQueryDocument(e)).toList());

  CategoryService._();
}