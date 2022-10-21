import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miaged/firebase/auth.dart';

class TextFieldMiaged {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  late final TextFormField textFormField;

  TextFieldMiaged({
    required String label,
    Icon? icon,
    List<String? Function(String?)?>? validators,
    bool? disabled,
    String? value,
    bool? obscureText,
    bool? enableSuggestions,
    bool? autocorrect,
  }) {
    textFormField = TextFormField(
      controller: controller,
      focusNode: focusNode,
      initialValue: value,
      enabled: !disabled!,
      validator: (value) {
        if (validators == null) return null;
        for (var validator in validators) {
          var result = validator!(value);
          if (result is String) {
            return result;
          }
        }
      },
      decoration: InputDecoration(
        labelText: label,
        icon: icon,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class Profil extends StatelessWidget {
  Profil({super.key});
  final textFields = [
    TextFieldMiaged(label: 'Nom', disabled: true, value: Auth.profilUser.lastname),
    TextFieldMiaged(label: 'Prénom', disabled: true, value: Auth.profilUser.firstname),
    TextFieldMiaged(label: 'E-mail', disabled: true, value: Auth.profilUser.userData?.email),
    TextFieldMiaged(label: 'Mot de passe', disabled: true, value: '.'*10),
    TextFieldMiaged(label: 'Adresse', disabled: true, value: Auth.profilUser.adress),
    TextFieldMiaged(label: 'Ville', disabled: true, value: Auth.profilUser.city),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ...textFields.map((e) => Container(margin: const EdgeInsets.only(bottom: 10), child: e.textFormField,)).toList(),
          ],
        ),
      ),
    );
  }
}