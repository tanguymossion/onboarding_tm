import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:onboarding_tm/pokemon_list.dart';
import 'package:onboarding_tm/pokemon_list_view.dart';

/*Future<Pokemon> fetchPokemon() async {
  final response =
      await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // log response
    print(Pokemon.fromJson(jsonDecode(response.body)));
    return Pokemon.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load pokemon');
  }
}*/

Future<PokemonList> fetchPokemons (http.Client client) async {
  final response =
      await client.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // log response
    print(PokemonList.fromJson(jsonDecode(response.body)));
    return PokemonList.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load pokemon');
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onboarding Pokemon',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Onboarding Pokemon'),
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
  //late Future<Pokemon> futurePokemon;
  late Future<PokemonList> futurePokemons;

  @override
  void initState() {
    super.initState();
    //futurePokemon = fetchPokemon();
    futurePokemons = fetchPokemons(http.Client());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: 
          PokemonListView(futurePokemons: futurePokemons),
        
    );
  }
}
