import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:onboarding_tm/home.dart';
import 'package:onboarding_tm/pokemon_details.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:onboarding_tm/signin.dart';
import 'package:onboarding_tm/signup.dart';
import 'firebase_options.dart';

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    // add signin/signup route
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return SignupPage(
        );
      },
    ),
    GoRoute(
      path: '/signin',
      builder: (BuildContext context, GoRouterState state) {
        return SigninPage(
        );
      },
    ),
    GoRoute(
        path: '/home',
        builder: (BuildContext context, GoRouterState state) {
          return const MyHomePage(
            title: 'Onboarding Pokemon',
          );
        }),
    GoRoute(
      path: '/details',
      builder: (BuildContext context, GoRouterState state) {
        if (state.extra != null) {
          return PokemonDetailsPage(pokemonName: state.extra as String);
        } else {
          return const MyHomePage(
            title: 'Onboarding Pokemon',
          );
        }
      },
    ),
  ],
);



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}


