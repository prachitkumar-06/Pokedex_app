import 'dart:convert';
import 'dart:math' as math;

import 'package:http/http.dart' as http;

import '../models/pokemon.dart';

class PokemonService {
  static const String baseUrl = 'https://pokeapi.co/api/v2';
  static const Duration requestTimeout = Duration(seconds: 15);
  static const int batchSize = 20;

  final http.Client _client;

  PokemonService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Pokemon>> getPokemonList({int limit = 151}) async {
    final response = await _client
        .get(Uri.parse('$baseUrl/pokemon?limit=$limit&offset=0'))
        .timeout(requestTimeout);

    if (response.statusCode != 200) {
      throw Exception(
        'PokéAPI returned status ${response.statusCode}.',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>? ?? [];

    final urls = results
        .map((item) => (item as Map<String, dynamic>)['url']?.toString())
        .whereType<String>()
        .toList();

    final pokemonList = <Pokemon>[];

    // Fetch details in small parallel batches: faster than sequential
    // requests without creating 151 simultaneous network connections.
    for (var start = 0; start < urls.length; start += batchSize) {
      final end = math.min(start + batchSize, urls.length);
      final batch = urls.sublist(start, end);

      final batchResults = await Future.wait(
        batch.map(getPokemonByUrl),
      );

      pokemonList.addAll(batchResults);
    }

    pokemonList.sort((a, b) => a.id.compareTo(b.id));
    return pokemonList;
  }

  Future<Pokemon> getPokemonByUrl(String url) async {
    final response =
        await _client.get(Uri.parse(url)).timeout(requestTimeout);

    if (response.statusCode != 200) {
      throw Exception(
        'PokéAPI returned status ${response.statusCode} for a Pokémon.',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return Pokemon.fromJson(data);
  }

  void dispose() {
    _client.close();
  }
}
