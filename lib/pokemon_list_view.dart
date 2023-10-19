import 'package:flutter/material.dart';
import 'package:onboarding_tm/pokemon_list.dart';
import 'package:onboarding_tm/pokemon_tile.dart';

class PokemonListView extends StatelessWidget {
  final Future<PokemonList> futurePokemons;

  const PokemonListView({super.key, required this.futurePokemons});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PokemonList>(
            future: futurePokemons,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.pokemonList.length,
                  itemBuilder: (context, index) {
                    return PokemonTile(name: snapshot.data!.pokemonList[index].name);
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