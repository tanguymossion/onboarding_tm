import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:onboarding_tm/pokemon.dart';
import 'package:onboarding_tm/pokemon_details.dart';
import 'dart:convert';

import 'package:onboarding_tm/pokemon_list.dart';
import 'package:onboarding_tm/pokemon_list_view.dart';

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const MyHomePage(
            title: 'Onboarding Pokemon',
          );
        }),
    GoRoute(
      path: '/details',
      builder: (BuildContext context, GoRouterState state) {
        if(state.extra != null) {
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

void main() {
  runApp(const MyApp());
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<PokemonList> futurePokemons;
  final searchController = TextEditingController();
  List<Pokemon> filteredPokemons = [];
  List<Pokemon> pokemons = [];

  Future<PokemonList> fetchPokemons() async {
    final response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151'));

    if (response.statusCode == 200) {
      setState(() {
        pokemons = PokemonList.fromJson(jsonDecode(response.body)).pokemonList;
        filteredPokemons = pokemons;
      });
      return PokemonList.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load pokemon');
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchControllerInput);
    futurePokemons = fetchPokemons();
  }

  void _onSearchControllerInput() {
    final text = searchController.text;
    setState(() {
      filteredPokemons =
          pokemons.where((pokemon) => pokemon.name.contains(text)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Search',
                ),
              )),
          PokemonListView(
              futurePokemons: futurePokemons, pokemons: filteredPokemons)
        ])));
  }
}
