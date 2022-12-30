import 'package:flutter/material.dart';
import 'package:miaged/models/validators.dart';
import 'package:miaged/services/category_service.dart';
import '../models/category.dart';

class DropdownCategories extends StatefulWidget {

  List<Category> categories = [];
  Category? category;
  void Function(Category? category)? onChange;

  DropdownCategories({super.key, this.onChange});

  @override
  State<StatefulWidget> createState() => DropdownCategoriesState();
}

class DropdownCategoriesState extends State<DropdownCategories> {

  DropdownCategoriesState() {
    CategoryService.instance.stream_categories.listen((event) {
      setState(() {
        widget.categories = event;
        if (widget.categories.isNotEmpty && widget.category == null) {
          if (widget.onChange != null) widget.onChange!(widget.category);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: DropdownButtonFormField<Category>(
        value: widget.category,
        items: widget.categories.map((category) {
          final name = category.name;
          return DropdownMenuItem(
            value: category,
            child: Text("${name[0].toUpperCase()}${name.substring(1).toLowerCase()}"),
          );
        }).toList(),
        onChanged: (value) {
          if (widget.onChange != null) widget.onChange!(value);
          setState(() => widget.category = value);
        },
        validator: (value) => Validators.required(value?.name ?? ""),
        decoration: const InputDecoration(
            prefixIcon: Icon(Icons.category),
            border: OutlineInputBorder()
        ),
      ),
    );
  }

}