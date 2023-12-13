library pokemon;

import 'dart:math';

import 'package:flutter/material.dart';

class RandomPokemon extends StatefulWidget {
  const RandomPokemon({super.key});

  @override
  State<RandomPokemon> createState() => _RandomPokemonState();
}

class _RandomPokemonState extends State<RandomPokemon> {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _getImagePath(),
      height: 200,
      width: 200,
    );
  }

  String _getImagePath() {
    const String basePath = 'packages/pokemon/assets/images/';
    const List<String> nameList = [
      'metapod.jpeg',
      'nidorina.jpeg',
      'spearow.jpeg',
      'zubat.jpeg',
    ];

    final random = Random();

    return basePath + nameList[random.nextInt(4)];
  }
}
