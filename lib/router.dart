import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:miaged/firebase/auth.dart';
import 'package:miaged/pages/home.dart';
import 'package:miaged/pages/log.dart';
import 'package:miaged/scaffold_bottom_navbar.dart';

class RouteConfig {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter instance = GoRouter(routes: <GoRoute>[
    GoRoute(
        path: '/',
        builder: (context, state) => const Home(),
        redirect: (context, state) async => !Auth.profilUser.isLogged ? '/login' : null,
        routes: [
          ShellRoute(
            navigatorKey: _shellNavigatorKey,
            builder: (context, state, child) => ScaffoldWithBottomNavBar(
                items: const [
                  ScaffoldWithNavBarTabItem(initialLocation: '', icon: Icon(Icons.store), label: 'Vitrine'),
                  ScaffoldWithNavBarTabItem(initialLocation: 'shapping_cart', icon: Icon(Icons.shopping_basket), label: 'Panier'),
                  ScaffoldWithNavBarTabItem(initialLocation: 'profil', icon: Icon(Icons.person), label: 'Profile')
                ],
                child: child
            ),
            routes: [
              GoRoute(
                path: '',
                pageBuilder: (context, state) => NoTransitionPage(child: null)
              ),
            ]
          )
        ]
    ),
    GoRoute(
        path: '/login',
        builder: (context, state) => LogIn(),
        redirect: (context, state) async => Auth.profilUser.isLogged ? '/' : null,
    )
  ]);
}