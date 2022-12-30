import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:miaged/components/drop_down_size.dart';
import 'package:miaged/components/dropdown_categories.dart';
import 'package:miaged/components/miaged_text_field.dart';
import 'package:miaged/models/clothe.dart';
import 'package:miaged/services/clothe_service.dart';

import '../models/validators.dart';

class AddClothe extends StatefulWidget {

  const AddClothe({super.key});

  @override
  State<StatefulWidget> createState() => _AddClotheState();
}

class _AddClotheState extends State<AddClothe> {
  final _formKey = GlobalKey<FormState>();

  Clothe clothe = Clothe(id: "", img: "", name: "", size: "", price: 0, category: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => GoRouter.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text("Ajouter")
      ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MiagedTextField(
                  label: "Nom",
                  icon: const Icon(Icons.text_fields),
                  validators: [
                    Validators.required,
                    Validators.min(4),
                    Validators.max(20),
                  ],
                  onChange: (value) => clothe.name = value ?? "",
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      child: DropdownSize(
                        onChange: (value) => clothe.size = value!
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: MiagedMoneyField(
                        label: "Prix",
                        onChange: (value) => clothe.price = double.tryParse(value ?? '') ?? 0
                      )
                    )
                  ],
                ),
                MiagedTextField(
                  label: "Image",
                  icon: const Icon(Icons.image),
                  validators: const [
                    Validators.required,
                    Validators.httpLink,
                  ],
                  onChange: (value) => clothe.img = value ?? "",
                ),
                DropdownCategories(
                  onChange: (category) => clothe.category = category?.name ?? "",
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      var valid = _formKey.currentState?.validate() ?? false;
                      if (valid) {
                        if (await ClotheService.addClothe(clothe)) {
                          _formKey.currentState!.reset();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              "Vêtement \"${clothe.name}\" est mis en vente.",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                            duration: const Duration(seconds: 3),
                            backgroundColor: Colors.blue[400],
                          ));
                          GoRouter.of(context).pop();
                          return;
                        }
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                            "Une erreur est survenue.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.red,
                        ));
                      }
                    },
                    child: const Text("Ajouter"),
                  ),
                ),
              ],
            )
          )
      ),
    );
  }

}