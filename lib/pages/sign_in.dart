import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:miaged/components/miaged_text_field.dart';

import '../services/auth.dart';
import '../models/validators.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});

  final _formKey = GlobalKey<FormState>();

  String? email;
  String? password;
  String? adress;
  String? zipcode;
  String? city;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Création d\'un compte')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              MiagedTextField(
                label: "Login",
                icon: const Icon(Icons.email),
                validators: const [Validators.email],
                onSave: (value) => email = value,
              ),
              MiagedTextField(
                label: 'Mot de passe',
                icon: const Icon(Icons.password),
                validators: const [Validators.password],
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                onSave: (value) => password = value,
              ),
              MiagedTextField(
                label: 'Adresse',
                icon: const Icon(Icons.location_on),
                validators: const [Validators.required],
                onSave: (value) => adress = value,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: MiagedTextField(
                      label: "Code postal",
                      icon: const Icon(Icons.local_post_office),
                      validators: const [Validators.required],
                      onSave: (value) => zipcode = value,
                    )
                  ),
                  Expanded(
                      flex: 5,
                      child: MiagedTextField(
                        label: "Ville",
                        icon: const Icon(Icons.location_city),
                        validators: const [Validators.required],
                        onSave: (value) => city = value,
                      )
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) return Colors.blue.withOpacity(.2);
                        if (states.contains(MaterialState.hovered)) return Colors.blue.withOpacity(.04);
                      })
                  ),
                  child: const Text("Créer", style: TextStyle(color: Colors.white, fontSize: 16.0),),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      var reponse = await Auth.register(
                        email: email!,
                        password: password!,
                        adress: adress!,
                        city: city!,
                        zipcode: zipcode!,
                      );
                      if (reponse == null) {
                        GoRouter.of(context).go('/login');
                      }
                    }
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: TextButton(
                  onPressed: () { GoRouter.of(context).go('/login'); },
                  child: const Text('Se connecter'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}