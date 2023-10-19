import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:onboarding_tm/pokemon.dart';
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
  final searchController = TextEditingController();
  List<Pokemon> filteredPokemons = [];
  List<Pokemon> pokemons = [];

  // Filter futurePokemon with searchController
  // https://stackoverflow.com/questions/63424588/how-to-filter-a-futurebuilder-in-flutter

Future<PokemonList> fetchPokemons () async {
  final response =
      await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // log response
    print(PokemonList.fromJson(jsonDecode(response.body)));
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
    searchController.addListener(_printLatestValue);
    //futurePokemon = fetchPokemon();
    futurePokemons = fetchPokemons();
  }

  void _printLatestValue() {
    final text = searchController.text;
    setState(() {
      filteredPokemons = pokemons.where((pokemon) => pokemon.name.contains(text)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body:
      SingleChildScrollView(child:
          Column(
            children:
            [Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search',
              ),
            )
              
            ),
            
          PokemonListView(futurePokemons: futurePokemons, pokemons: filteredPokemons)])
        
    ));
  }
}
