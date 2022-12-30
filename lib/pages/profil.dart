import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:miaged/services/auth.dart';

import '../models/text_field_miaged.dart';

class Profil extends StatelessWidget {
  Profil({super.key});

  final _textFields = [
    TextFieldMiaged(label: 'Login', disabled: true, value: Auth.profilUser?.login),
    TextFieldMiaged(label: 'Mot de passe', disabled: true, value: '.'*10),
    TextFieldMiaged(label: 'Adresse', disabled: true, value: Auth.profilUser?.adress),
    TextFieldMiaged(label: 'Code postal', disabled: true, value: Auth.profilUser?.zipcode),
    TextFieldMiaged(label: 'Ville', disabled: true, value: Auth.profilUser?.city),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'),),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ..._textFields.map((e) => Container(margin: const EdgeInsets.only(bottom: 20), child: e.textFormField)).toList(),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextButton.icon(
                onPressed: () => GoRouter.of(context).go("/profil/add"),
                icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                label: const Text("Ajouter  vêtement", style: TextStyle(color: Colors.white)),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  foregroundColor: MaterialStateProperty.all(Colors.blue),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () async {
                var res = await Auth.signOut();
                if (res) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text(
                      "Vous avez été déconnecté.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    duration: const Duration(seconds: 3),
                    backgroundColor: Colors.blue[400],
                  ));
                  GoRouter.of(context).go('/login');
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                    "Erreur déconnections.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                ));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red[600]),
                foregroundColor: MaterialStateProperty.all(Colors.red[600]),
                padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
              ),
              icon: const Icon(Icons.power_settings_new, color: Colors.white),
              label: const Text(
                "Se déconnecter",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}