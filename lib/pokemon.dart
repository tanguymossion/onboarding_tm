class Pokemon {
  final int? pokemonId;
  final String name;
  final List<String>? types;

  const Pokemon({
    required this.pokemonId,
    required this.name,
    required this.types,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      pokemonId: json['id'],
      name: json['name'],
      types:
          json['types'] != null
              ? List<String>.from(
                  json['types'].map((type) => type['type']['name']))
              : null,
    );
  }
}