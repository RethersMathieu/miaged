import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:miaged/components/card_clothe.dart';
import 'package:miaged/models/clothe.dart';
import 'package:miaged/services/category_service.dart';
import 'package:miaged/services/clothe_service.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import '../models/category.dart';

class Showcase extends StatefulWidget {

  const Showcase({ super.key });

  @override
  State<Showcase> createState() => _ShowcaseState();
}

class _ShowcaseState extends State<Showcase> {

  List<Category> _categories = [];
  
  Widget _initSpinner() {
    return const Center(
      child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator()),
    );
  }

  Widget _initGridViewClothes(List<Clothe> clothes) {
      return GridView.builder(
        itemCount: clothes.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          var clothe = clothes[index];
          return CardClothe(
            clothe: clothe,
            onTap: (clothe) => GoRouter.of(context).go('/showcase/clothe/${clothe!.id}'),
          );
        },
      );
  }

  StreamBuilder<List<Clothe>> _initStream() {
    return StreamBuilder<List<Clothe>>(
      stream: ClotheService.snapshotClothes(categories: _categories),
      builder: (BuildContext context, AsyncSnapshot<List<Clothe>> snapshot) {
        if (snapshot.hasError) {
          return Text('Erreur lors du chargement des vetements : ${snapshot.error}');
        } else if (snapshot.connectionState == ConnectionState.none) {
          return const Text('Non connecté à la base de donnée.');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return _initSpinner();
        }
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) return const Text("Aucun vêtements disponible");
          return _initGridViewClothes(snapshot.data!);
        }
        return const Text("Aucun vêtements disponible");
      },
    );
  }

  void _showMultiSelect(BuildContext context) async {
    var categories = await CategoryService.instance.futureCategories;
    await showModalBottomSheet(
      isScrollControlled: true, // required for min/max child size
      context: context,
      builder: (ctx) {
        return  MultiSelectBottomSheet(
          items: categories.map((e) => MultiSelectItem(e, e.name)).toList(),
          initialValue: _categories,
          listType: MultiSelectListType.CHIP,
          onConfirm: (values) {
            setState(() {
              _categories = values;
            });
          },
          maxChildSize: 0.8,
        );
      },
    );
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acheter')),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () => _showMultiSelect(context),
                    icon: const Icon(Icons.category, color: Colors.white),
                    label: Text(
                      "Catégorie${_categories.isNotEmpty ? "${_categories.length > 1 ? "s" : ""}  (${_categories.length})" : ""}",
                      style: const TextStyle(color: Colors.white)
                    ),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      foregroundColor: MaterialStateProperty.all(Colors.blue),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0))
                      )
                    ),
                  )
                ],
              ),
            )
          ),
          Expanded(
            flex: 9,
            child: _initStream(),
          )
        ],
      )
    );
  }
}