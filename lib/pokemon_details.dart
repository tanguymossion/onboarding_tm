import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:onboarding_tm/favorite_provider.dart';
import 'dart:convert';

import 'package:onboarding_tm/pokemon.dart';

class PokemonDetailsPage extends ConsumerStatefulWidget {
  final String pokemonName;

  const PokemonDetailsPage({super.key, required this.pokemonName});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return PokemonDetailsPageState();
  }
}

class PokemonDetailsPageState extends ConsumerState<PokemonDetailsPage> {
  late Future<Pokemon> _pokemonDetails;

  @override
  void initState() {
    super.initState();
    _pokemonDetails = _fetchPokemonDetails(widget.pokemonName);
  }

  Future<Pokemon> _fetchPokemonDetails(String pokemonName) async {
    final response = await http.get(Uri.parse(
        'https://pokeapi.co/api/v2/pokemon/${pokemonName.toLowerCase()}'));
    if (response.statusCode == 200) {
      return Pokemon.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Pokemon details');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFav = ref.watch(favoriteProvider).contains(widget.pokemonName);
    final favIcon = isFav ? Icons.favorite : Icons.favorite_border;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.pokemonName),
      ),
      body: FutureBuilder<Pokemon>(
        future: _pokemonDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final pokemonDetails = snapshot.data!;
            return Center(
                child: Column(
              children: [
                
                Container(
                  // add fav icon button at bottom left of container
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.black)),
                  child:
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Image.network(pokemonDetails.spriteUrl, fit: BoxFit.fill),
                        IconButton(
                          icon: Icon(favIcon),
                          onPressed: () {
                            ref
                                .read(favoriteProvider.notifier)
                                .switchFavorite(widget.pokemonName);
                          },
                        ),
                      ],
                )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${pokemonDetails.name}'),
                    Text('Height: ${pokemonDetails.height}'),
                    Text('Weight: ${pokemonDetails.weight}'),
                    Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.black)),
                      child: Text('Types: ${pokemonDetails.types.join(', ')}'),
                    ),
                  ],
                ),
              ],
            ));
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to load Pokemon details'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
