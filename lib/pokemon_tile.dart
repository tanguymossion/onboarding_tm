import 'package:flutter/material.dart';

class PokemonTile extends StatelessWidget {
  final String name;

  const PokemonTile({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          // TODO: Navigate to PokemonDetailPage
        },
        child: ListTile(
          title: Text(name[0].toUpperCase() + name.substring(1)),
          leading: const CircleAvatar(
            child: Icon(Icons.pets),
          ),
        ),
      ),
    );
  }
}
