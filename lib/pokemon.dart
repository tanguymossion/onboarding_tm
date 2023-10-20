class Pokemon {
  final int? pokemonId;
  final String name;
  final List<String> types;
  final String spriteUrl;
  final int? height;
  final int? weight;

  const Pokemon({
    required this.pokemonId,
    required this.name,
    required this.types,
    required this.spriteUrl,
    required this.height,
    required this.weight,
  });

  factory Pokemon.fromString(String pokemonName) {
    return Pokemon(
      pokemonId: null,
      name: pokemonName,
      types: [],
      spriteUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/100px-No_image_available.svg.png',
      height: null,
      weight: null,
    );
  }

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      pokemonId: json['id'],
      name: json['name'],
      types:
          json['types'] != null
              ? List<String>.from(
                  json['types'].map((type) => type['type']['name']))
              : List.empty(),
      spriteUrl: json['sprites'] != null ? json['sprites']['front_default'] :
          'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/100px-No_image_available.svg.png',
      height: json['height'],
      weight: json['weight'],
    );
  }
}