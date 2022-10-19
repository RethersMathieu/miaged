import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:miaged/firebase/auth.dart';
import 'package:miaged/validators.dart';

import '../firebase_options.dart';

class LogIn extends StatelessWidget {
  LogIn({super.key});
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailTEC = TextEditingController();
  final FocusNode emailFN = FocusNode();

  final TextEditingController passwordTEC = TextEditingController();
  final FocusNode passwordFN = FocusNode();

  @override
  Widget build(BuildContext context) {

    Future<FirebaseApp> _initializeFirebase() async {
      FirebaseApp firebaseApp =  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Text("BONJOUR"),
          ),
        );
      }
      return firebaseApp;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Login"),),
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailTEC,
                        focusNode: emailFN,
                        validator: (value) => Validators.email(email: value ?? ""),
                      ),
                      TextFormField(
                        controller: passwordTEC,
                        focusNode: passwordFN,
                        validator: (value) => Validators.password(password: value ?? ""),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    var reponse = await Auth.signIn(email: emailTEC.text, password: passwordTEC.text);
                                    if (reponse is User) {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(builder: (context) => const Text("BONJOUR!"))
                                      );
                                    }
                                  }
                                },
                                child: const Text("Se connecter", style: TextStyle(color: Colors.white),),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

}