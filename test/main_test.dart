
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:onboarding_tm/main.dart';
import 'package:onboarding_tm/pokemon_list.dart';

import 'main_test.mocks.dart';



@GenerateMocks([http.Client])

void main() {
  
  group('fetchPokemons', () {
    test('returns PokemonList if the http call completes successfully', () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client
              .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151')))
          .thenAnswer((_) async => http.Response('{"name": "Bulbasaur"}', 200));

      expect(await fetchPokemons(client), isA<PokemonList>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client
              .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchPokemons(client), throwsException);
    });
  });
}