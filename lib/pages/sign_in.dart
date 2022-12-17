import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/auth.dart';
import '../models/text_field_miaged.dart';
import '../models/validators.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});

  final _formKey = GlobalKey<FormState>();

  final _loginField = TextFieldMiaged(label: 'Login', validators: [(value) => Validators.email(email: value ?? "")]);
  final _passwordField = TextFieldMiaged(
      label: 'Mot de passe',
      validators: [(value) => Validators.password(password: value ?? "")],
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false
  );
  final _adressField = TextFieldMiaged(label: 'Adresse', validators: [(value) => Validators.required(value: value ?? '')]);
  final _zipcodeField = TextFieldMiaged(label: 'Code postal', validators: [(value) => Validators.required(value: value ?? '')]);
  final _cityField = TextFieldMiaged(label: 'Ville', validators: [(value) => Validators.required(value: value ?? '')]);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Création d`\'un compte')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(margin: const EdgeInsets.only(bottom: 20), child: _loginField.textFormField),
              Container(margin: const EdgeInsets.only(bottom: 20), child: _passwordField.textFormField),
              Container(margin: const EdgeInsets.only(bottom: 20), child: _adressField.textFormField),
              Container(margin: const EdgeInsets.only(bottom: 20), child: _cityField.textFormField),
              Container(margin: const EdgeInsets.only(bottom: 20), child: _zipcodeField.textFormField),
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
                        email: _loginField.value!,
                        password: _passwordField.value!,
                        adress: _adressField.value!,
                        city: _cityField.value!,
                        zipcode: _zipcodeField.value!,
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