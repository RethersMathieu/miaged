import 'dart:js';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:miaged/pages/home.dart';
import 'package:miaged/pages/log.dart';

class RouteConfig {
  static GoRouter instance = GoRouter(routes: <GoRoute>[
    GoRoute(
        path: '/',
        builder: (context, state) => Home(),
        redirect: (context, state) async {
          User? user = FirebaseAuth.instance.currentUser;
          return user == null ? '/login' : null;
        }
    ),
    GoRoute(
        path: '/login',
        builder: (context, state) => LogIn(),
        redirect: (context, state) async {
          User? user = FirebaseAuth.instance.currentUser;
          return user != null ? '/' : null;
        }
    )
  ]);
}