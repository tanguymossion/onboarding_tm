import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:onboarding_tm/favorites.dart';
import 'package:onboarding_tm/pokemon.dart';
import 'dart:convert';

import 'package:onboarding_tm/pokemon_list.dart';
import 'package:onboarding_tm/pokemon_list_view.dart';

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

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Favorites',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void disconnect() {
    FirebaseAuth.instance.signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You have been logged out'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          leading:
              IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              disconnect();
              context.go('/');
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          onTap: _onItemTapped,
        ),
        body: _selectedIndex == 0
            ? SingleChildScrollView(
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
              ]))
            : const FavoritesPage());
  }
}
