
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onboarding_tm/main.dart';
import 'package:onboarding_tm/pokemon.dart';
import 'package:onboarding_tm/pokemon_list.dart';
import 'package:onboarding_tm/pokemon_list_view.dart';
import 'package:onboarding_tm/pokemon_tile.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

void main() {
  
  testWidgets('MyHomePage has a title and a PokemonList', (WidgetTester tester) async {
    final MockClient client = MockClient();
    
    final List<Pokemon> pokemons = <Pokemon>[
      const Pokemon(pokemonId: 1, name: 'bulbasaur', types: <String>['grass', 'poison']),
      const Pokemon(pokemonId: 2, name: 'ivysaur', types: <String>['grass', 'poison']),
      const Pokemon(pokemonId: 3, name: 'venusaur', types: <String>['grass', 'poison']),
    ];

    // Mock PokemonList
    final PokemonList pokemonList = PokemonList(pokemonList: pokemons);

    // Mock HTTP call
    when(() => client.get("https://pokeapi.co/api/v2/pokemon?limit=3" as Uri)).thenAnswer((_) async => http.Response('{"results": [{"name": "bulbasaur"}, {"name": "ivysaur"}, {"name": "venusaur"}]}', 200));
    // Error "Bad state: No method stub was called from within `when()`. Was a real method called, or perhaps an extension method?"
    
    //when(() => fetchPokemons()).thenAnswer((_) async => pokemonList);
    // Error "Exception: Failed to load pokemon"
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that MyHomePage has a title
    expect(find.text('Onboarding Pokemon'), findsOneWidget);

    // Verify that MyHomePage has a PokemonListView
    expect(find.byType(PokemonListView), findsOneWidget);

    // Verify that PokemonListView has a ListView
    expect(find.byType(ListView), findsOneWidget);

    // Verify that ListView has 3 PokemonTile
    expect(find.byType(PokemonTile), findsNWidgets(3));
  });
}