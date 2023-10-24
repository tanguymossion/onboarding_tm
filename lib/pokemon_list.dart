import 'package:onboarding_tm/pokemon.dart';

class PokemonList {
  final List<Pokemon> pokemonList;

  PokemonList({required this.pokemonList});

  factory PokemonList.fromJson(Map<String, dynamic> json) {
    return PokemonList(
      pokemonList: List<Pokemon>.from(
        json['results'].map((pokemon) => Pokemon.fromJson(pokemon)),
      ),
    );
  }
}