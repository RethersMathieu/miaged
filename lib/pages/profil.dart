import 'package:flutter/material.dart';
import 'package:miaged/firebase/auth.dart';

import '../models/text_field_miaged.dart';

class Profil extends StatelessWidget {
  Profil({super.key});
  final textFields = [
    TextFieldMiaged(label: 'Login', disabled: true, value: Auth.profilUser.login),
    TextFieldMiaged(label: 'Mot de passe', disabled: true, value: '.'*10),
    TextFieldMiaged(label: 'Adresse', disabled: true, value: Auth.profilUser.adress),
    TextFieldMiaged(label: 'Code postal', disabled: true, value: Auth.profilUser.zipcode),
    TextFieldMiaged(label: 'Ville', disabled: true, value: Auth.profilUser.city),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'),),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ...textFields.map((e) => Container(margin: const EdgeInsets.only(bottom: 20), child: e.textFormField)).toList(),
          ],
        ),
      ),
    );
  }
}