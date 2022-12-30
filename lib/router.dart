import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:miaged/pages/add_clothe.dart';
import 'package:miaged/services/auth.dart';
import 'package:miaged/pages/clothe_detail.dart';
import 'package:miaged/pages/log.dart';
import 'package:miaged/pages/profil.dart';
import 'package:miaged/pages/shapping_cart.dart';
import 'package:miaged/pages/showcase.dart';
import 'package:miaged/pages/sign_in.dart';
import 'package:miaged/scaffold_bottom_navbar.dart';

class RouteConfig {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static FutureOr<String?> redirectionToLog(BuildContext context, GoRouterState state) => Auth.profilUser == null ? '/login' : null;
  static FutureOr<String?> redirectionToShowCase(BuildContext context, GoRouterState state) => Auth.profilUser != null ? '/showcase' : null;

  static GoRouter instance = GoRouter(
    initialLocation: '/showcase',
    navigatorKey: _rootNavigatorKey,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => ScaffoldWithBottomNavBar(
          items: const [
            ScaffoldWithNavBarTabItem(initialLocation: '/showcase', icon: Icon(Icons.store), label: 'Acheter'),
            ScaffoldWithNavBarTabItem(initialLocation: '/shapping_cart', icon: Icon(Icons.shopping_basket), label: 'Panier'),
            ScaffoldWithNavBarTabItem(initialLocation: '/profil', icon: Icon(Icons.person), label: 'Profile')
          ],
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/showcase',
            pageBuilder: (context, state) => const NoTransitionPage(child: Showcase()),
            redirect: redirectionToLog,
            routes: [
              GoRoute(
                path: 'clothe/:id',
                builder: (context, state) => ClotheDetail(id: state.params['id'] ?? ''),
              )
            ]
          ),
          GoRoute(
            path: '/shapping_cart',
            pageBuilder: (context, state) => const NoTransitionPage(child: ShappingCart()),
            redirect: redirectionToLog,
            routes: [
              GoRoute(
                path: 'clothe/:id',
                builder: (context, state) => ClotheDetail(id: state.params['id'] ?? ''),
              )
            ]
          ),
          GoRoute(
            path: '/profil',
            pageBuilder: (context, state) => NoTransitionPage(child: Profil()),
            redirect: redirectionToLog,
            routes: [
              GoRoute(
                  path: 'add',
                  builder: (context, state) => const AddClothe(),
              ),
            ]
          )
        ]
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LogIn(),
        redirect: redirectionToShowCase
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => SignIn(),
        redirect: redirectionToShowCase
      ),
    ]
  );
}