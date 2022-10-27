import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:miaged/firebase/auth.dart';
import 'package:miaged/validators.dart';

class LogIn extends StatelessWidget {
  LogIn({super.key});
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailTEC = TextEditingController();
  final FocusNode _emailFN = FocusNode();

  final TextEditingController _passwordTEC = TextEditingController();
  final FocusNode _passwordFN = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connexion")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  controller: _emailTEC,
                  focusNode: _emailFN,
                  validator: (value) => Validators.email(email: value ?? ""),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email),
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  controller: _passwordTEC,
                  focusNode: _passwordFN,
                  validator: (value) => Validators.password(password: value ?? ""),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.password),
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    overlayColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) return Colors.blue.withOpacity(.2);
                      if (states.contains(MaterialState.hovered)) return Colors.blue.withOpacity(.04);
                    })
                  ),
                  child: const Text("Connecter", style: TextStyle(color: Colors.white, fontSize: 16.0),),
                  onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        var reponse = await Auth.signIn(email: _emailTEC.text, password: _passwordTEC.text);
                        if (reponse is! User) {
                          Fluttertoast.showToast(
                            msg: "E-mail ou mot de passe incorrect",
                            toastLength: Toast.LENGTH_SHORT,
                            timeInSecForIosWeb: 5,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                            webShowClose: true,
                          );
                        } else {
                          GoRouter.of(context).go('/showcase');
                        }
                      }
                    },
                ),
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