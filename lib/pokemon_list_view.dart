import 'package:flutter/material.dart';
import 'package:onboarding_tm/pokemon.dart';
import 'package:onboarding_tm/pokemon_list.dart';
import 'package:onboarding_tm/pokemon_tile.dart';

class PokemonListView extends StatelessWidget {
  final Future<PokemonList>? futurePokemons;
  final List<Pokemon> pokemons;

  const PokemonListView({super.key, required this.futurePokemons, required this.pokemons});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PokemonList>(
            future: futurePokemons,
            builder: (context, snapshot) {
              if (snapshot.hasData || futurePokemons == null) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: pokemons.length,
                  itemBuilder: (context, index) {
                    return PokemonTile(pokemon: pokemons[index]);
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.lightBlueAccent,
                  ),
                );
              }
            },
    );
  }
}