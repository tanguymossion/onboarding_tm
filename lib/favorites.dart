import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onboarding_tm/pokemon.dart';
import 'package:onboarding_tm/pokemon_list_view.dart';
import 'package:onboarding_tm/favorite_provider.dart';
import 'package:onboarding_tm/pokemon_tile.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> pokemonsName = ref.watch(favoriteProvider.notifier).getAllFavorites();
    List<Pokemon> pokemons = [];
    for (var pokemonName in pokemonsName) {
      pokemons.add(Pokemon.fromString(pokemonName));
    }

    return 
      pokemons.isEmpty ?
        const Center(
          child: Text('No favorites yet'),
        ) :
        ListView(
          children: pokemons.map((pokemon) => PokemonTile(pokemon: pokemon)).toList(),
        );
  }
}
