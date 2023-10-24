import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onboarding_tm/pokemon.dart';
import 'package:onboarding_tm/pokemon_list.dart';
import 'package:onboarding_tm/pokemon_tile.dart';
import 'package:http/http.dart' as http;

final elementsPageStateProvider =
    StateNotifierProvider.autoDispose<PageNotifier, int>(
        (ref) => PageNotifier());

class PageNotifier extends StateNotifier<int> {
  PageNotifier() : super(0);

  void increment() => state++;
}

final elementsByPageProvider =
    FutureProvider.autoDispose.family<PokemonList, int>((ref, page) async {
  const int pokemonsPerPage =
      20; // Vous pouvez ajuster ce nombre selon vos besoins
  final offset = page * pokemonsPerPage;
  final response = await http.get(Uri.parse(
      'https://pokeapi.co/api/v2/pokemon?limit=$pokemonsPerPage&offset=$offset'));

  if (response.statusCode == 200) {
    return PokemonList.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load pokemon');
  }
});

final elementsFutureProvider = FutureProvider.autoDispose<List<Pokemon>>(
  (ref) async {
    final currentPage = ref.watch(elementsPageStateProvider);
    var elements = <Pokemon>[];
    final pageContent =
        await ref.watch(elementsByPageProvider(currentPage).future);
    elements.addAll(pageContent.pokemonList);

    if (elements.isEmpty) {
      throw Exception("EmptyContentException");
    }
    return elements;
  },
  dependencies: [
    elementsPageStateProvider,
    elementsByPageProvider,
  ],
);

final hasReachedMaxPageElementsProvider = FutureProvider.autoDispose<bool>(
  (ref) async {
    final currentPage = ref.watch(elementsPageStateProvider);
    for (var page = 0; page <= currentPage; page++) {
      final pageElements = await ref.watch(elementsByPageProvider(page).future);
      if (pageElements.pokemonList.isEmpty) {
        return true;
      }
    }
    print("Reached end of list hasReachedMaxPageElementsProvider");
    return false;
  },
  dependencies: [
    elementsPageStateProvider,
    elementsByPageProvider,
  ],
);

// Composant PokemonListView
class PokemonListView extends ConsumerStatefulWidget {
  final String searchText;

  const PokemonListView(this.searchText, {Key? key}) : super(key: key);

  @override
  ConsumerState<PokemonListView> createState() => PokemonListViewState();
}

class PokemonListViewState extends ConsumerState<PokemonListView> {
  late final ScrollController _scrollController;
  final _listKey = GlobalKey();
  final pokemonsNotifier = ValueNotifier<List<Pokemon>>([]);

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController = ScrollController();

    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final hasReachedMax =
            await ref.read(hasReachedMaxPageElementsProvider.future);
        if (!hasReachedMax) {
          ref.read(elementsPageStateProvider.notifier).increment();
          final newPokemons = await ref.read(elementsFutureProvider.future);
          pokemonsNotifier.value += newPokemons;
        }
      }
    });
  }

  void _loadInitialData() async {
    final initialPokemons = await ref.read(elementsFutureProvider.future);
    pokemonsNotifier.value = initialPokemons;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    pokemonsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Pokemon>>(
      valueListenable: pokemonsNotifier,
      builder: (context, pokemons, child) {
        // Filtrer les pokémons en fonction du texte de recherche
        List<Pokemon> filteredPokemons;
        if (widget.searchText.isNotEmpty) {
          filteredPokemons = pokemons
              .where((pokemon) => pokemon.name.contains(widget.searchText))
              .toList();
        } else {
          filteredPokemons = pokemons;
        }
        return ListView.builder(
          itemBuilder: (context, index) {
            if (index == filteredPokemons.length &&
                filteredPokemons.length > 20) {
              // Afficher un indicateur de chargement avec une taille de 40
              return Center(
                  child: Container(
                padding: const EdgeInsets.all(20),
                child: const SizedBox(
                  height: 40,
                  width: 40,
                  child:
                      CircularProgressIndicator(color: Colors.lightBlueAccent),
                ),
              ));
            } else if (index == filteredPokemons.length &&
                filteredPokemons.length <= 20) {
              return const SizedBox();
            } else {
              return PokemonTile(pokemon: filteredPokemons[index]);
            }
          },
          key: _listKey,
          controller: _scrollController,
          itemCount:
              filteredPokemons.length + 1, // Mettez à jour le itemCount ici
        );
      },
    );
  }
}
