import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:miaged/components/miaged_text_field.dart';

import '../services/auth.dart';
import '../models/validators.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<StatefulWidget> createState() => _SignInState();

}

class _SignInState extends State<SignIn> {

  final _formKey = GlobalKey<FormState>();

  String? email;
  String? password;
  String? adress;
  String? zipcode;
  String? city;

  bool _onLoad = false;

  TextButton _buttonCreate() => TextButton(
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        overlayColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) return Colors.blue.withOpacity(.2);
          if (states.contains(MaterialState.hovered)) return Colors.blue.withOpacity(.04);
          return null;
        })
    ),
    child: const Text("Créer", style: TextStyle(color: Colors.white, fontSize: 16.0),),
    onPressed: () {
      if (_formKey.currentState!.validate()) {
        setState(() => _onLoad = true);
        Auth.register(
            email: email!,
            password: password!,
            adress: adress!,
            city: city!,
            zipcode: zipcode!,
            callback: (response) {
              if (response == null) {
                GoRouter.of(context).go('/login');
              }
            }
        );
        setState(() => _onLoad = false);
      }
    },
  );

  final _circularProgress = const CircularProgressIndicator();

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
                onChange: (value) => email = value,
              ),
              MiagedTextField(
                label: 'Mot de passe',
                icon: const Icon(Icons.password),
                validators: const [Validators.password],
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                onChange: (value) => password = value,
              ),
              MiagedTextField(
                label: 'Adresse',
                icon: const Icon(Icons.location_on),
                validators: const [Validators.required],
                onChange: (value) => adress = value,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: MiagedTextField(
                      label: "Code postal",
                      icon: const Icon(Icons.local_post_office),
                      validators: const [Validators.required],
                      onChange: (value) => zipcode = value,
                    )
                  ),
                  Expanded(
                      flex: 5,
                      child: MiagedTextField(
                        label: "Ville",
                        icon: const Icon(Icons.location_city),
                        validators: const [Validators.required],
                        onChange: (value) => city = value,
                      )
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: _onLoad ? _circularProgress : _buttonCreate()
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