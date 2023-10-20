import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:onboarding_tm/favorite_provider.dart';
import 'package:onboarding_tm/pokemon.dart';


class PokemonTile extends ConsumerWidget {
  final Pokemon pokemon;
  const PokemonTile({Key? key, required this.pokemon}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(favoriteProvider).contains(pokemon.name);
    final favIcon = isFav ? Icons.favorite : Icons.favorite_border;

    return Card(
      child: InkWell(
        child: ListTile(
          onTap: () => {context.go('/details', extra: pokemon.name)},
          title:
              Text(pokemon.name[0].toUpperCase() + pokemon.name.substring(1)),
          leading: const CircleAvatar(
            child: Icon(Icons.pets),
          ),
          trailing: IconButton(
            icon: Icon(favIcon),
            onPressed: () {
              ref.read(favoriteProvider.notifier).switchFavorite(pokemon.name);
            },
          ),
        ),
      ),
    );
  }
}
