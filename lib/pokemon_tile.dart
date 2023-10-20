import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onboarding_tm/pokemon.dart';

class PokemonTile extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonTile({Key? key, required this.pokemon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => {context.go('/details', extra: pokemon.name)
        },
        child: ListTile(
          title: Text(pokemon.name[0].toUpperCase() + pokemon.name.substring(1)),
          leading: const CircleAvatar(
            child: Icon(Icons.pets),
          ),
        ),
      ),
    );
  }
}
