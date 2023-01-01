import 'package:flutter/material.dart';
import 'package:miaged/models/validators.dart';
import 'package:miaged/services/category_service.dart';
import '../models/category.dart';

class DropdownCategories extends StatefulWidget {
  final void Function(Category? category)? onChange;

  const DropdownCategories({super.key, this.onChange});

  @override
  State<StatefulWidget> createState() => DropdownCategoriesState();
}

class DropdownCategoriesState extends State<DropdownCategories> {
  Category? category;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: CategoryService.instance.futureCategories,
      builder: (BuildContext streamContext, AsyncSnapshot<List<Category>> snapshot) {
        var categories = snapshot.data ?? [];
        return Container(
          padding: const EdgeInsets.all(5.0),
          child: DropdownButtonFormField<Category>(
            value: category,
            items: categories.map((category) {
              final name = category.name;
              return DropdownMenuItem(
                value: category,
                child: Text("${name[0].toUpperCase()}${name.substring(1).toLowerCase()}"),
              );
            }).toList(),
            onChanged: (value) {
              if (widget.onChange != null) widget.onChange!(value);
              setState(() => category = value);
            },
            validator: (value) => Validators.required(value?.name ?? ""),
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder()
            ),
          ),
        );
      }
    );
  }

}