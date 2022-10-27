import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:miaged/firebase/auth.dart';
import 'package:miaged/pages/home.dart';
import 'package:miaged/pages/log.dart';
import 'package:miaged/pages/profil.dart';
import 'package:miaged/pages/shapping_cart.dart';
import 'package:miaged/scaffold_bottom_navbar.dart';

class RouteConfig {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static FutureOr<String?> redirectionToLog(BuildContext context, GoRouterState state) => !Auth.profilUser.isLogged ? '/login' : null;

  static GoRouter instance = GoRouter(
    initialLocation: '/showcase',
    navigatorKey: _rootNavigatorKey,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => ScaffoldWithBottomNavBar(
          items: const [
            ScaffoldWithNavBarTabItem(initialLocation: '/showcase', icon: Icon(Icons.store), label: 'Vitrine'),
            ScaffoldWithNavBarTabItem(initialLocation: '/shapping_cart', icon: Icon(Icons.shopping_basket), label: 'Panier'),
            ScaffoldWithNavBarTabItem(initialLocation: '/profil', icon: Icon(Icons.person), label: 'Profile')
          ],
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/showcase',
            pageBuilder: (context, state) => const NoTransitionPage(child: Home()),
            redirect: redirectionToLog
          ),
          GoRoute(
              path: '/shapping_cart',
              pageBuilder: (context, state) => const NoTransitionPage(child: ShappingCart()),
              redirect: redirectionToLog
          ),
          GoRoute(
              path: '/profil',
              pageBuilder: (context, state) => NoTransitionPage(child: Profil()),
              redirect: redirectionToLog
          )
        ]
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LogIn(),
        redirect: (context, state) async => Auth.profilUser.isLogged ? '/showcase' : null,
      )
    ]
  );
}