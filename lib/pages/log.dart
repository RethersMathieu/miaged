import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:miaged/components/miaged_text_field.dart';
import 'package:miaged/services/auth.dart';
import 'package:miaged/models/validators.dart';

class LogIn extends StatefulWidget {
  LogIn({super.key});
  final _formKey = GlobalKey<FormState>();

  bool _load = false;

  State<StatefulWidget> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {


  String? email;
  String? password;

  _button() {
    return TextButton.icon(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          overlayColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) return Colors.blue.withOpacity(.2);
            if (states.contains(MaterialState.hovered)) return Colors.blue.withOpacity(.04);
          }),
          padding: MaterialStateProperty.all(const EdgeInsets.all(15))
      ),
      icon: const Icon(Icons.power_settings_new_outlined, color: Colors.white),
      label: const Text("Connecter", style: TextStyle(color: Colors.white, fontSize: 16.0),),
      onPressed: () async {
        if (widget._formKey.currentState!.validate()) {
          widget._load = true;
          var reponse = await Auth.signIn(email: email!, password: password!);
          if (reponse is! User) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                "E-mail ou mot de passe incorrect",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ));
          } else {
            GoRouter.of(context).go('/showcase');
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connexion")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: widget._formKey,
          child: Column(
            children: [
              MiagedTextField(
                label: "E-mail",
                icon: const Icon(Icons.email),
                validators: const [Validators.email],
                onChange: (value) => email = value,
              ),
              MiagedTextField(
                label: "Mot de passe",
                icon: const Icon(Icons.password),
                validators: const [Validators.password],
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                onChange: (value) => password = value,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: (() {
                  if (widget._load) return const CircularProgressIndicator();
                  return _button();
                })()
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: TextButton(
                  onPressed: () { GoRouter.of(context).go('/register'); },
                  child: const Text('Créer un compte'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}