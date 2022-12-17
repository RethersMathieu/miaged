import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:miaged/services/auth.dart';
import 'package:miaged/models/validators.dart';

class LogIn extends StatefulWidget {
  LogIn({super.key});
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailTEC = TextEditingController();
  final FocusNode _emailFN = FocusNode();

  final TextEditingController _passwordTEC = TextEditingController();
  final FocusNode _passwordFN = FocusNode();

  bool _load = false;

  State<StatefulWidget> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  _button() {
    return TextButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          overlayColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) return Colors.blue.withOpacity(.2);
            if (states.contains(MaterialState.hovered)) return Colors.blue.withOpacity(.04);
          })
      ),
      child: const Text("Connecter", style: TextStyle(color: Colors.white, fontSize: 16.0),),
      onPressed: () async {
        if (widget._formKey.currentState!.validate()) {
          widget._load = true;
          var reponse = await Auth.signIn(email: widget._emailTEC.text, password: widget._passwordTEC.text);
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
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  controller: widget._emailTEC,
                  focusNode: widget._emailFN,
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
                  controller: widget._passwordTEC,
                  focusNode: widget._passwordFN,
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